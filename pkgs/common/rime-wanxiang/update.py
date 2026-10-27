import json
import os
import re
import subprocess
import sys
import urllib.request
from typing import Any, List

def nth(idx: int, lst: List) -> Any:
    return None if idx >= len(lst) else lst[idx]


IS_COMMIT = nth(1, sys.argv)
SCRIPT_DIR = os.path.dirname(os.path.relpath(__file__))

REQUEST_TIMEOUT = 30


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
    with urllib.request.urlopen(
        "https://api.github.com/repos/amzxyz/rime_wanxiang/releases",
        timeout=REQUEST_TIMEOUT,
    ) as resp:
        releases = json.load(resp)
    re_compile = re.compile(regex)
    for i in releases:
        tag_name = i["tag_name"]
        if re_compile.match(tag_name):
            return i
    else:
        print("No corresponding version found...")


def nix_b32_from_sha256_hex(hex_hash: str) -> str:
    """sha256 hex -> nix base32，与 nix-prefetch-url 输出同格式。

    Nix base32 字符集不含 e/o/u/t 等易混淆字母；编码时把 hash 字节按
    little-endian 视作大整数，从高位到低位每 5 bit 一个字符。
    """
    chars = "0123456789abcdfghijklmnpqrsvwxyz"
    n = int.from_bytes(bytes.fromhex(hex_hash), "little")
    digits = []
    for _ in range((len(hex_hash) * 4 + 4) // 5):
        digits.append(chars[n & 0x1F])
        n >>= 5
    return "".join(reversed(digits))


def get_asset_sha256(assets: List[dict[str, Any]], zip_name: str) -> str:
    """从 release assets 中按文件名取官方 digest（sha256:<hex>）并转 nix base32。"""
    asset = next((a for a in assets if a.get("name") == zip_name), None)
    if asset is None:
        raise ValueError(f"asset {zip_name!r} not found in release assets")
    algo, _, hex_hash = (asset.get("digest") or "").partition(":")
    if algo != "sha256" or len(hex_hash) != 64:
        raise ValueError(
            f"asset {zip_name!r} has unexpected digest {asset.get('digest')!r}, "
            "expect 'sha256:<hex>'"
        )
    return nix_b32_from_sha256_hex(hex_hash)


def get_info(url, version, pname, sha256) -> dict[str, Any]:
    return {
        "url": url,
        "version": version,
        "sha256": sha256,
        "pname": pname,
    }


def get_infos(release: dict[str, Any], pnames, is_fmt: bool = False) -> dict[str, Any]:
    # https://github.com/amzxyz/rime_wanxiang/releases/download/v8.2.2/rime-wanxiang-flypy-fuzhu.zip
    version = release["tag_name"]
    url_format = "https://github.com/amzxyz/rime_wanxiang/releases/download/{version}/{zip_name}"
    result = {}
    for pname, pname_zip in pnames.items():
        zip_name = pname_zip.format(version=version) if is_fmt else pname_zip
        url = url_format.format(version=version, zip_name=zip_name)
        result[pname] = get_info(
            url, version, pname, get_asset_sha256(release["assets"], zip_name)
        )

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
                url_infos,
                {
                    "base": "rime-wanxiang-base.zip",
                    "zrm": "rime-wanxiang-zrm-fuzhu.zip",
                    "tiger": "rime-wanxiang-tiger-fuzhu.zip",
                    "moqi": "rime-wanxiang-moqi-fuzhu.zip",
                    "flypy": "rime-wanxiang-flypy-fuzhu.zip",
                    "wubi": "rime-wanxiang-wubi-fuzhu.zip",
                    # NOTE: see @https://github.com/amzxyz/rime_wanxiang/pull/317
                    # jdh 已被移除
                    # "jdh": "rime-wanxiang-jdh-fuzhu.zip",
                    "hanxin": "rime-wanxiang-hanxin-fuzhu.zip",
                },
            )
        else:
            return None
    else:
        new_version = url_infos["tag_name"]
        latest_sources = get_infos(
            url_infos,
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
