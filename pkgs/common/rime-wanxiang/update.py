import json
import os
import re
import subprocess
import sys
from typing import Any, List

import requests

def nth(idx: int, lst: List) -> Any:
    return None if idx >= len(lst) else lst[idx]


IS_COMMIT = nth(1, sys.argv)
SCRIPT_DIR = os.path.dirname(os.path.relpath(__file__))


def commit_source(msg: str):
    current_dir = os.getcwd()
    os.chdir(SCRIPT_DIR)
    for i in ["sources.json", "source.json"]:
        if os.path.isfile(i):
            subprocess.run(f"git add ./{i}", shell=True)
    subprocess.run(f"git commit -m '{msg}'", shell=True)
    os.chdir(current_dir)


def get_current_src(f):
    """将 sources.json 中的数据转换为 python 字典。"""
    if os.path.isfile(f):
        with open(f, encoding="utf-8", mode="r") as text:
            return json.load(text)


def save_current_src(f, sources):
    """更新 source.json 文件."""
    with open(f, encoding="utf-8", mode="w") as text:
        json.dump(sources, text, indent=2)


def get_latest_version_info_by_infos(regex: str = r"^(v([0-9][0-9.]+))") -> List:
    """从 api 上获取最新的 version 数据。"""
    resp = requests.get(
        "https://api.github.com/repos/amzxyz/rime_wanxiang/releases"
    )
    re_compile = re.compile(regex)
    for i in resp.json():
        tag_name = i["tag_name"]
        if re_compile.match(tag_name):
            return i
    else:
        print("No corresponding version found...")


def get_latest_version_by_url() -> List:
    return requests.get(
        "https://api.github.com/repose/amzxyz/rime_wanxiang/releases/latest"
    ).json()


def get_hash(url: str) -> str:
    result = subprocess.run(["nix-prefetch-url", url], stdout=subprocess.PIPE)
    if result.returncode != 0:
        raise RuntimeError(
            "nix-prefetch-url exited with error {}".format(result.returncode)
        )
    return result.stdout.decode("utf-8").strip()


def get_info(url, version, pname) -> dict[str, Any]:
    return {
        "url": url,
        "version": version,
        "sha256": get_hash(url),
        "pname": pname,
    }


def get_infos(prefix_url, version, pnames, is_fmt: bool = False) -> dict[str, Any]:
    # https://github.com/amzxyz/rime_wanxiang/releases/download/v8.2.2/rime-wanxiang-flypy-fuzhu.zip
    url_format = "{prefix_url}/releases/download/{version}/{zip_name}"
    result = {}
    for pname, pname_zip in pnames.items():
        zip_name = pname_zip.format(version=version) if is_fmt else pname_zip
        url = url_format.format(
            prefix_url=prefix_url, version=version, zip_name=zip_name
        )
        result[pname] = get_info(url, version, pname)

    return result


def update_src():
    target_file = os.path.join(SCRIPT_DIR, "sources.json")
    old_sources = get_current_src(target_file)
    url_infos = get_latest_version_info_by_infos()
    latest_sources = {}
    old_version = "∅"
    if old_sources:
        if old_sources["base"]["version"] != url_infos["tag_name"]:
            old_version = old_sources["base"]["version"]
            new_version = url_infos["tag_name"]
            latest_sources = get_infos(
                "https://github.com/amzxyz/rime_wanxiang",
                new_version,
                {
                    "base": "rime-wanxiang-base.zip",
                    "zrm": "rime-wanxiang-zrm-fuzhu.zip",
                    "tiger": "rime-wanxiang-tiger-fuzhu.zip",
                    "moqi": "rime-wanxiang-moqi-fuzhu.zip",
                    "flypy": "rime-wanxiang-flypy-fuzhu.zip",
                    "wubi": "rime-wanxiang-wubi-fuzhu.zip",
                    "jdh": "rime-wanxiang-jdh-fuzhu.zip",
                    "hanxin": "rime-wanxiang-hanxin-fuzhu.zip",
                },
            )
        else:
            return None
    else:
        new_version = url_infos["tag_name"]
        latest_sources = get_infos(
            "https://github.com/amzxyz/rime_wanxiang",
            new_version,
            {
                "base": "rime-wanxiang-base.zip",
                "zrm": "rime-wanxiang-zrm-fuzhu.zip",
                "tiger": "rime-wanxiang-tiger-fuzhu.zip",
                "moqi": "rime-wanxiang-moqi-fuzhu.zip",
                "flypy": "rime-wanxiang-flypy-fuzhu.zip",
                "wubi": "rime-wanxiang-wubi-fuzhu.zip",
                "jdh": "rime-wanxiang-jdh-fuzhu.zip",
                "hanxin": "rime-wanxiang-hanxin-fuzhu.zip",
            },
        )
    save_current_src(target_file, latest_sources)
    if IS_COMMIT:
        commit_source(f"update rime-wanxiang {old_version} -> {new_version}")

if __name__ == '__main__':
    update_src()
