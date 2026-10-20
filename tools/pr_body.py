#!/usr/bin/env python3
# 说明:
# 1. 供 .github/workflows/update.yml 生成 PR body：基于 master...flakebot
#    （默认 master...HEAD）的实际差异实时重建 PR 描述，每次运行都反映最新内容
# 2. 覆盖三类变更：
#     1. nvfetcher:  _sources/generated.json 的版本/链接变化
#     2. updatePy:   pkgs/**/sources.json（或 source.json）的版本变化
#     3. flake.lock: 各输入 rev/version 的变化
# 3. 用法: python3 tools/pr_body.py [base-ref]，结果写入 $PR_BODY_FILE
# 4. 每个变更分区用 <details>/<summary> 包成可折叠块（GitHub 原生支持），
#    默认只展示标题和变更计数，避免 PR 页面被几十条版本条目攬屏

from __future__ import annotations

import json
import os
import subprocess
import sys
from datetime import datetime, timezone

BASE = sys.argv[1] if len(sys.argv) > 1 else "master"
OUT = os.environ.get("PR_BODY_FILE", "/tmp/pr-body.md")
# 可选：额外写一行摘要，供 update.yml dispatch 给 build.yml 的 run-name 使用
RUN_NAME_FILE = os.environ.get("PR_RUN_NAME_FILE", "")

MAX_PER_LIST = 50  # 单个列表最多展示条数，超出折叠
MAX_COMMITS = 30
MAX_RUN_NAME = 100  # 过长在 Actions 列表里会被截断，提前省略
COUNTER_LABELS = {"upd": "更新", "add": "新增", "rem": "移除"}


def git(*args: str) -> str:
    # 失败时返回空串（如文件在 base ref 中不存在）
    r = subprocess.run(["git", *args], capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else ""


def json_at(path: str, ref: str | None) -> dict:
    """读取指定 ref（None = 工作区）下的 json 文件，读取失败返回 {}"""
    if ref is None:
        try:
            with open(path, encoding="utf-8") as f:
                return json.load(f)
        except (OSError, json.JSONDecodeError):
            return {}
    r = subprocess.run(["git", "show", f"{ref}:{path}"], capture_output=True, text=True)
    if r.returncode != 0:
        return {}
    try:
        return json.loads(r.stdout)
    except json.JSONDecodeError:
        return {}


def fmt_ver(v: object) -> str:
    return f"`{v}`" if v else "`∅`"


def version_diff(old: dict, new: dict) -> tuple[dict[str, list[str]], list[str]]:
    """对比 {name: {version, src, ...}} 两个映射

    返回（更新/新增/移除 三组行, 发生变化的包名列表）
    """
    o = {k: v for k, v in (old or {}).items() if isinstance(v, dict)}
    n = {k: v for k, v in (new or {}).items() if isinstance(v, dict)}
    upd, add, rem = [], [], []
    names: list[str] = []
    for k in sorted(set(o) | set(n)):
        vo = (o.get(k) or {}).get("version")
        vn = (n.get(k) or {}).get("version")
        so = (o.get(k) or {}).get("src") or {}
        sn = (n.get(k) or {}).get("src") or {}
        if k in o and k in n:
            if vo != vn:
                upd.append(f"- **{k}**: {fmt_ver(vo)} → {fmt_ver(vn)}")
                names.append(k)
            elif (so.get("url"), so.get("sha256")) != (sn.get("url"), sn.get("sha256")):
                upd.append(f"- **{k}**: {fmt_ver(vo)}（链接/哈希变更，版本不变）")
                names.append(k)
        elif k in n:
            add.append(f"- **{k}**: {fmt_ver(vn)}")
            names.append(k)
        else:
            rem.append(f"- **{k}**: {fmt_ver(vo)}")
            names.append(k)
    return {"upd": upd, "add": add, "rem": rem}, names


def render_groups(groups: dict[str, list[str]], n: int = MAX_PER_LIST) -> list[str]:
    out: list[str] = []
    for key in ("upd", "add", "rem"):
        if groups.get(key):
            out.append(f"**{COUNTER_LABELS[key]}（{len(groups[key])}）**")
            out += cap(groups[key], n)
    return out


def count_badge(groups: dict[str, list[str]]) -> str:
    """折叠块 summary 用的一行统计，如 ' · 更新 3 · 新增 1'（无变更返回空串）"""
    bits = [
        f"{COUNTER_LABELS[k]} {len(groups[k])}"
        for k in ("upd", "add", "rem")
        if groups.get(k)
    ]
    return " · " + " · ".join(bits) if bits else ""


def details(summary: str, lines: list[str]) -> list[str]:
    """把一段 Markdown 包成可折叠块（GitHub 用 <details>/<summary> 实现）

    两个必须遵守的细节，否则 GitHub 不会渲染内部 Markdown：
      1. <details>、<summary> 与正文之间必须留空行
      2. 正文不能缩进，否则会被当成代码块
    """
    return ["<details>", f"<summary>{summary}</summary>", "", *lines, "", "</details>"]


def cap(lines: list[str], n: int = MAX_PER_LIST) -> list[str]:
    return (
        lines
        if len(lines) <= n
        else lines[:n] + [f"- ……（其余 {len(lines) - n} 项省略）"]
    )


def changed_files() -> list[str]:
    return [
        line
        for line in git("diff", "--name-only", f"{BASE}...HEAD").splitlines()
        if line.strip()
    ]


def lock_lines() -> list[str]:
    def nodes(d: dict) -> dict:
        return {
            k: (v.get("locked") or {})
            for k, v in (d.get("nodes") or {}).items()
            if isinstance(v, dict)
        }

    o = nodes(json_at("flake.lock", BASE))
    n = nodes(json_at("flake.lock", None))
    lines = []
    for name in sorted(n):
        old, new = o.get(name), n.get(name)
        if old == new:
            continue

        def desc(x: dict) -> str:
            if not x:
                return "`∅`"
            bits = []
            if x.get("rev"):
                bits.append(str(x["rev"])[:7])
            if x.get("version"):
                bits.append(f"v{x['version']}")
            return f"`{' '.join(bits)}`" if bits else "`已变更`"

        lines.append(f"- **{name}**: {desc(old)} → {desc(new)}")
    return lines


def commit_lines() -> list[str]:
    commits = [
        line
        for line in git("log", "--oneline", f"{BASE}..HEAD").splitlines()
        if line.strip()
    ]
    return [f"- {c}" for c in cap(commits, MAX_COMMITS)]


def build_run_name(pkg_names: list[str], lock_count: int) -> str:
    """按实际变更内容拼一行 run 摘要（供 build.yml 的 run-name 展示）

    例：Update src: ripgrep, fd 等 5 个 · flake.lock: 3 输入
    无变更时返回空串，由调用方回退到固定标题。
    """
    bits: list[str] = []
    if pkg_names:
        head = ", ".join(pkg_names[:3])
        more = f" 等 {len(pkg_names)} 个" if len(pkg_names) > 3 else ""
        bits.append(f"src: {head}{more}")
    if lock_count:
        bits.append(f"flake.lock: {lock_count} 输入")
    return "Update " + " · ".join(bits) if bits else ""


def header() -> list[str]:
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M")
    run_url = os.environ.get("RUN_URL", "")
    run_no = os.environ.get("RUN_NUMBER", "")
    run_link = f"[update.yml #{run_no}]({run_url})" if run_url else "update.yml"
    modes = []
    task_keys = (
        ("lock", "RUN_LOCK"),
        ("nvfetcher", "RUN_NVFETCHER"),
        ("update.py", "RUN_UPDATEPY"),
    )
    for label, key in task_keys:
        if os.environ.get(key):
            modes.append(f"{label} {'✓' if os.environ[key] == 'true' else '—'}")
    mode_txt = f" · 执行任务：{' · '.join(modes)}" if modes else ""
    event = os.environ.get("EVENT_NAME", "")
    # 明细默认折叠（<details>），所以额外提示一句，避免读者以为更新为空
    tip = "> 明细默认折叠，点开分区标题即可展开全部条目。"
    if not event and not mode_txt:
        note = f"> 自动更新 PR。body 由 {run_link} 于 {now} UTC 基于 `{BASE}...flakebot` 差异实时重建。"
        return ["> [!NOTE]", note, tip]
    return [
        "> [!NOTE]",
        f"> 自动更新 PR。body 由 {run_link} 于 {now} UTC 基于 `{BASE}...flakebot` 差异实时重建。",
        f"> 触发事件：`{event}`{mode_txt}",
        tip,
    ]


def main() -> None:
    changed = changed_files()
    sections: list[tuple[str, list[str]]] = []
    pkg_names: list[str] = []
    lock_count = 0

    if "_sources/generated.json" in changed:
        old = json_at("_sources/generated.json", BASE)
        groups, names = version_diff(old, json_at("_sources/generated.json", None))
        pkg_names += names
        lines = render_groups(groups)
        if lines:
            sections.append(
                (
                    f"nvfetcher 源更新 <code>_sources/generated.json</code>{count_badge(groups)}",
                    lines,
                )
            )

    data_files = (
        p
        for p in changed
        if p.startswith("pkgs/") and p.endswith(("sources.json", "source.json"))
    )
    for f in sorted(data_files):
        groups, names = version_diff(json_at(f, BASE), json_at(f, None))
        pkg_names += names
        lines = render_groups(groups, n=100)
        if lines:
            sections.append((f"<code>{f}</code>{count_badge(groups)}", lines))

    if "flake.lock" in changed:
        lines = lock_lines()
        lock_count = len(lines)
        if lines:
            sections.append((f"flake.lock 输入更新 · {lock_count} 项", cap(lines, 30)))

    lines = commit_lines()
    if lines:
        sections.append(("提交记录", lines))

    out = "\n".join(header()) + "\n"
    # 每个 section 用 <details> 折叠，默认只看得到标题和变更计数，点开才看明细
    for summary, lines in sections:
        out += "\n" + "\n".join(details(summary, lines)) + "\n"
    if not sections:
        out += "\n本次运行未产生文件变更（所有源均已是最新）。\n"
    with open(OUT, "w", encoding="utf-8") as f:
        f.write(out)
    print(f"PR body written to {OUT} ({len(out)} bytes, {len(sections)} sections)")

    if RUN_NAME_FILE:
        name = build_run_name(pkg_names, lock_count)
        if not name:
            # 当前没有实际变更时，回退到 workflow 传入的固定标题
            name = os.environ.get("PR_TITLE_FALLBACK", "Update src and lock")
        if len(name) > MAX_RUN_NAME:
            name = name[: MAX_RUN_NAME - 1] + "…"
        with open(RUN_NAME_FILE, "w", encoding="utf-8") as f:
            f.write(name + "\n")
        print(f"run name written to {RUN_NAME_FILE}: {name}")


if __name__ == "__main__":
    main()
