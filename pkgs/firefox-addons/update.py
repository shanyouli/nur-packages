import json
import os
import re
import subprocess
import sys
import logging

import requests

logging.basicConfig(format="%(levelname)s:%(message)s", level=logging.INFO)

# AMO 页面 HTML 结构频繁改版（2025-07 大改版后安装按钮由前端 JS 渲染，
# 且 class 名不再稳定），解析页面不可靠；官方 API v5 是文档化的稳定接口。
AMO_API_URL = "https://addons.mozilla.org/api/v5/addons/addon/{slug}/"
# 默认的 python-requests UA 会被部分站点拦截，使用常规浏览器 UA
HEADERS = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0"
}
REQUEST_TIMEOUT = 30


def nth(idx, lst):
    return lst[idx] if idx < len(lst) else None


IS_COMMIT = nth(1, sys.argv)
SCRIPT_DIR = os.path.dirname(os.path.relpath(__file__))


def commit_source(msg):
    current_dir = os.getcwd()
    os.chdir(SCRIPT_DIR)
    for i in ["sources.json", "source.json"]:
        if os.path.isfile(i):
            logging.info(f"git add {i}")
            subprocess.run(["git", "add", f"./{i}"], check=False)

    logging.info("git commit some file")
    # 用列表参数传递消息，避免 shell 拼接在消息含空格/换行时出错
    subprocess.run(["git", "commit", "-m", msg], check=False)
    os.chdir(current_dir)


def nix_prefix_url(url: str) -> str:
    result = subprocess.run(["nix-prefetch-url", url], stdout=subprocess.PIPE)
    if result.returncode != 0:
        raise RuntimeError(
            "nix-prefetch-url exited with error {}".format(result.returncode)
        )
    return result.stdout.decode("utf-8").strip()


def get_version_from_url(url: str) -> str | None:
    """从 XPI 直链解析版本号，如 .../noscript-13.6.36.xpi -> 13.6.36"""
    m = re.search(r"-([0-9.]+)\.xpi$", url)
    return m.group(1) if m else None


def get_firefox_addon_info(name: str) -> dict:
    """通过 AMO 官方 API v5 获取插件当前版本的下载直链与版本号"""
    logging.info(f"get {name} infos")
    resp = requests.get(AMO_API_URL.format(slug=name), headers=HEADERS, timeout=REQUEST_TIMEOUT)
    if resp.status_code == 404:
        raise ValueError(f"Addon {name!r} not found on AMO (404), please check the slug")
    resp.raise_for_status()
    info = resp.json()
    current = info.get("current_version") or {}
    file = current.get("file") or {}
    url = file.get("url")
    if not url or not url.endswith(".xpi"):
        raise ValueError(f"Addon {name!r} has no downloadable .xpi in current_version")
    version = current.get("version") or get_version_from_url(url)
    return {"url": url, "version": version}


def make_source(name: str, info: dict) -> dict:
    logging.info(f"get {name} sha256.")
    return {
        "url": info["url"],
        "version": info["version"],
        "sha256": nix_prefix_url(info["url"]),
        "pname": name,
    }


def get_current_src(f):
    if os.path.isfile(f):
        with open(f, encoding="utf-8", mode="r") as text:
            return json.load(text)


def save_current_src(f, sources):
    with open(f, encoding="utf-8", mode="w") as text:
        json.dump(sources, text, indent=2)


def build_commit_message(updates: list[str], added: list[str], removed: list[str]) -> str:
    """构建 conventional + emoji 风格的提交信息：subject 统计摘要，body 分组明细"""
    counts = []
    if updates:
        counts.append(f"更新 {len(updates)}")
    if added:
        counts.append(f"新增 {len(added)}")
    if removed:
        counts.append(f"移除 {len(removed)}")
    # 单个插件更新时，subject 直接携带版本变化，一眼可见
    if not added and not removed and len(updates) == 1:
        subject = f"chore(🤖): 更新 firefox-addons 插件 {updates[0]}"
    else:
        subject = f"chore(🤖): 更新 firefox-addons 插件（{'、'.join(counts)}）"
    sections = []
    if updates:
        sections.append("更新:\n" + "\n".join(f"- {u}" for u in updates))
    if added:
        sections.append("新增:\n" + "\n".join(f"- {a}" for a in added))
    if removed:
        sections.append("移除:\n" + "\n".join(f"- {r}" for r in removed))
    return subject + "\n\n" + "\n\n".join(sections)


def init_sources(add_name):
    sources = {}
    added = []
    for i in add_name:
        info = get_firefox_addon_info(i)
        sources[i] = make_source(i, info)
        logging.info(f"{i}, version: {sources[i]['version']}")
        added.append(f"{i}: {sources[i]['version']}")
    return sources, added


def update_src(add_name: list[str]):
    target_file = os.path.join(SCRIPT_DIR, "sources.json")
    updates = []
    added = []
    removed = []
    failed = []
    sources = get_current_src(target_file) or {}
    next_sources = {}
    if sources:
        for i in add_name:
            logging.info(f"check {i} ...")
            try:
                info = get_firefox_addon_info(i)
            except Exception as e:
                logging.warning(f"skip {i}: {e}")
                failed.append(f"{i}: {e}")
                continue
            if i in sources and sources[i]["url"] == info["url"]:
                next_sources[i] = sources.pop(i)
            else:
                logging.info(f"update {i} ...")
                current_version = sources[i]["version"] if i in sources else "∅"
                next_sources[i] = make_source(i, info)
                logging.info(f"{i}, version: {next_sources[i]['version']}")
                if i in sources:
                    updates.append(f"{i}: {current_version} -> {next_sources[i]['version']}")
                    sources.pop(i)  # 从旧集合移除，避免被计入“移除”分组
                else:
                    added.append(f"{i}: {next_sources[i]['version']}")
        for k, v in sources.items():
            removed.append(f"{k}: {v['version']} -> ∅")
    else:
        next_sources, added = init_sources(add_name)
    if updates or added or removed:
        save_current_src(target_file, next_sources)
        if IS_COMMIT:
            commit_source(build_commit_message(updates, added, removed))
    if failed:
        raise SystemExit(
            "some addons failed to update:\n" + "\n".join(failed)
        )


if __name__ == "__main__":
    update_src(
        [
            "noscript",
            "browserpass-ce",
            "download-with-aria2",
            "surfingkeys_ff",
            "auto-tab-discard",
            "user-agent-string-switcher",
            "violentmonkey",
            "styl-us",
            "privacy-pass",
            "ublock-origin",
            "immersive-translate",
            "darkreader",
            "chrome-mask",
            "zeroomega",
            "easy-image-blocker",
            "kiss-translator",
            "raindropio",
        ]
    )
