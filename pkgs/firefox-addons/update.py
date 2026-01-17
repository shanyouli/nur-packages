import json
import os
import re
import subprocess
import sys
import logging

import requests
from bs4 import BeautifulSoup

logging.basicConfig(format="%(levelname)s:%(message)s", level=logging.INFO)

def nth(idx, lst):
    if idx >= len(lst):
        return None
    else:
        return lst[idx]


IS_COMMIT = nth(1, sys.argv)
SCRIPT_DIR = os.path.dirname(os.path.relpath(__file__))


def commit_source(msg):
    current_dir = os.getcwd()
    os.chdir(SCRIPT_DIR)
    for i in ["sources.json", "source.json"]:
        if os.path.isfile(i):
            logging.info(f"git add {i}")
            subprocess.run(f"git add ./{i}", shell=True)

    logging.info("git commit some file")
    subprocess.run(f"git commit -m '{msg}'", shell=True)
    os.chdir(current_dir)


def nix_prefix_url(url: str) -> str:
    result = subprocess.run(["nix-prefetch-url", url], stdout=subprocess.PIPE)
    if result.returncode != 0:
        raise RuntimeError(
            "nix-prefetch-url exited with error {}".format(result.returncode)
        )
    return result.stdout.decode("utf-8").strip()


def get_firefox_addons_xpi(name: str) -> str:
    logging.info("get %s infos" % name)
    html = requests.get(f"https://addons.mozilla.org/en-US/firefox/addon/{name}").text
    soup = BeautifulSoup(html, "html.parser")
    for i in soup.find_all("a", class_="InstallButtonWrapper-download-link"):
        if "href" in i.attrs and i["href"].endswith(".xpi"):
            return i["href"]
    else:
        xpi_soup = soup.find(href=re.compile(r"\.xpi$"))
        if xpi_soup:
            return xpi_soup.get("href")
        else:
            raise ValueError(f"The extensions of {name}  not found")


def get_version(url: str) -> str:
    import time
    re_pattern = re.search(r"-([0-9.]+).xpi", url)
    return re_pattern.group(1) if re_pattern is not None else time.strftime("%y%m%d%H%M")


def get_current_src(f):
    if os.path.isfile(f):
        with open(f, encoding="utf-8", mode="r") as text:
            return json.load(text)


def save_current_src(f, sources):
    with open(f, encoding="utf-8", mode="w") as text:
        json.dump(sources, text, indent=2)


def init_sources(add_name):
    sources = {}
    update_list = []
    for i in add_name:
        url = get_firefox_addons_xpi(i)
        logging.info(f"get {i} version, sha256.")
        sources[i] = {
            "url": url,
            "version": get_version(url),
            "sha256": nix_prefix_url(url),
            "pname": i,
        }
        logging.info(f"{i}, version: {sources[i]["version"]}")
        update_list.append(f"{i}: ∅ -> {sources[i]['version']}")
    return sources, update_list


def update_src(add_name: list[str]):
    target_file = os.path.join(SCRIPT_DIR, "sources.json")
    update_list = []
    sources = get_current_src(target_file)
    next_sources = {}
    if sources:
        for i in add_name:
            logging.info(f"check {i} ...")
            url = get_firefox_addons_xpi(i)
            sources_contain_i = True if i in sources else False
            if sources_contain_i and sources[i]["url"] == url:
                next_sources[i] = sources.pop(i)
            else:
                logging.info(f"update {i} ...")
                next_sources[i] = {
                    "url": url,
                    "version": get_version(url),
                    "sha256": nix_prefix_url(url),
                    "pname": i,
                }
                logging.info(f"{i}, version: {sources[i]["version"]}")
                current_version = sources[i]["version"] if sources_contain_i else "∅"
                next_version = next_sources[i]["version"]
                update_list.append(f"{i}: {current_version} -> {next_version}")
                if sources_contain_i:
                    sources.pop(i)
        for k, v in sources.items():
            update_list.append(f"{k}: {v['version']} -> ∅")
    else:
        next_sources, update_list = init_sources(add_name)
    if update_list:
        save_current_src(target_file, next_sources)
        if IS_COMMIT:
            msg = "Update\n" + "\n".join(update_list)
            commit_source(msg)


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
