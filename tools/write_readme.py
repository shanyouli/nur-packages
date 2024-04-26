import json
import os
import subprocess
import time


def get_app_shows():
    return r"""## apps

- `ci`: Perform the verification process for github's workflows
- `devci`: Test commands used when developing or writing a package
- `nvfetcher`: Use the nvfetcher command to update the original code of the package
- `bbdownDeps`: Updating bbdown's dependencies using bbdown's own update scripts
- `updatePy`: Updating the source code of certain packages using python scripts
- `upFlake`: Automatic `inputs` source
- `readme`: Automatic generation of readme.md files using python
"""


def get_packages_info(p):
    os.chdir(p)
    result = subprocess.run(
        "nix eval -f tests/pkgmeta.nix --json", capture_output=True, shell=True
    )
    if result.returncode != 0:
        return
    os.chdir(CURRENT_DIR)
    packages = json.loads(result.stdout.decode().strip())
    results = {}
    for k, v in packages.items():
        for n, p in v.items():
            if n in results:
                results[n]["system"].append(k)
                if p["broken"]:
                    results[n]["broken"].append(f"**{k}**")
            else:
                results[n] = p
                results[n]["system"] = [k]
                results[n]["broken"] = [f"**{k}**"] if p["broken"] else []
                results[n]["version"] = p["version"] if p["version"] else ""
    total_pkgs = len(results.keys())
    firefox_addons = {}
    linux_apps = {}
    darwin_apps = {}
    py_apps = {}
    common = {}
    for k, v in results.items():
        if k.startswith("firefox-addons"):
            firefox_addons[k] = v
        elif k.startswith("python-apps"):
            py_apps[k] = v
        elif k.startswith("darwin-apps"):
            darwin_apps[k] = v
        elif k.startswith("linux-apps"):
            linux_apps[k] = v
        else:
            common[k] = v
    return total_pkgs, common, linux_apps, darwin_apps, firefox_addons, py_apps


def pname_fn(name, data, prefix=""):
    msg = data["pname"] if "pname" in data else name
    msg = msg.removeprefix(prefix)
    if "url" in data:
        return f'[**{msg}**]({data["url"]})'
    else:
        return msg


def show_pacakges(data: dict, typology: str) -> str:
    msg = f"### {typology}\n"
    info = "\n<details>"
    if typology == "firefox-addons":
        sum_msg = "<b>firefox extension</b>, default support for all systems that support firefox. "
        prefix = "firefox-addons-"
    elif typology == "python3-apps":
        sum_msg = "Installing <b>python programs</b> with nix. "
        prefix = "python-apps-"
    elif typology == "linux":
        sum_msg = "Only support for <b>aarch64-linux</b>, <b>x86_64-linux</b>. "
        prefix = "linux-apps-"
    elif typology == "darwin":
        sum_msg = "Only support for <b>aarch64-darwin</b>, <b>x86_64-darwin</b>, Most <b>GUI packages</b> only support <b>aarch64-darwin</b>. "
        prefix = "darwin-addons-"
    else:
        sum_msg= "Default support for <b>aarch64-linux</b>,<b>aarch64-darwin</b>,<b>x86_64-linux</b> and <b>x86_64-darwin</b>. "
        prefix = ""
    info += f"\n<summary>{sum_msg}, Total: <b>{len(data.keys())}</b> packages </summary>"
    msg += f"""{info}

|name|broken system|version|description|
|:---|:---|:---|:---|
"""
    msg += "\n".join(
        [
            rf"|{pname_fn(k, v, prefix)}|{' '.join(v['broken'])}|{v['version']}|{v['description']}|"
            for k, v in data.items()
        ]
    )

    msg += "\n</details>"
    return msg


def get_package_show(p) -> str:
    total_pkgs, common, linux_apps, darwin_apps, firefox_addons, python3_apps = get_packages_info(p)
    msg = f"""## packages

Currently only builds on **aarch64-darwin** and **x86_64-linux**, total: **{total_pkgs}** packages.

"""
    if common:
        msg += show_pacakges(common, typology="common")
        msg += "\n\n"
    if linux_apps:
        msg += show_pacakges(linux_apps, typology="linux")
        msg += "\n\n"

    if darwin_apps:
        msg += show_pacakges(darwin_apps, typology="darwin")
        msg += "\n\n"

    if firefox_addons:
        msg += show_pacakges(firefox_addons, typology="firefox-addons")
        msg += "\n\n"
    if python3_apps:
        msg += show_pacakges(python3_apps, typology="python3-apps")
        msg += "\n\n"

    return msg


def main(p):
    title = "# Shanyouli NUR PACKAGES"
    title_info = f"""

![Build and populate cache](https://github.com/shanyouli/nur-packages/workflows/Build%20and%20populate%20cache/badge.svg)

[![Cachix Cache](https://img.shields.io/badge/cachix-shanyouli-blue.svg)](https://shanyouli.cachix.org)

- LAST_MODIFY: {time.strftime("%Y-%m-%d %H:%M:%S %Z")}
"""
    how_to_use = """## How to use

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nur-shanyouli = {
      url = "github:shanyouli/nur-packages";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ ... }: {
          nixpkgs.overlays = [inputs.nur-shanyouli.overlay];
          # Binary cache (optional)
          nix.settings.substituters = [ "https://shanyouli.cachix.org" ];
          nix.settings.trusted-public-keys = [ "shanyouli.cachix.org-1:19ndCE7zQfn5vIVLbBZk6XG0D7Ago7oRNNgIRV/Oabw=" ];
        })
      ];
    };
  };
}
```
"""
    binaray_cache = """## Binary Cache

```nix
{
  nix.settings.substituters = [ "https://shanyouli.cachix.org" ];
  nix.settings.trusted-public-keys = [ "shanyouli.cachix.org-1:19ndCE7zQfn5vIVLbBZk6XG0D7Ago7oRNNgIRV/Oabw=" ];
}
```
"""
    apps_msg = get_app_shows()
    packages_msg = get_package_show(p)

    with open(os.path.join(p, "README.md"), mode="w+", encoding="utf-8") as f:
        f.write(title)
        f.write(title_info)
        f.write("\n\n")
        f.write(how_to_use)
        f.write("\n\n")
        f.write(binaray_cache)
        f.write("\n\n")
        f.write(apps_msg)
        f.write("\n\n")
        f.write(packages_msg)
    os.chdir(p)
    if (
        subprocess.run(
            'git diff HEAD^1 README.md | grep "-"', shell=True, capture_output=True
        ).returncode
        == 0 and IS_COMMIT
    ):
        subprocess.run("git add README.md", shell=True)
        subprocess.run(
            f"git commit -m 'update README.md {time.strftime('%Y-%m-%d %H:%M:%S %Z')}'",
            shell=True,
        )
    os.chdir(CURRENT_DIR)


def get_flake(dir: str = None) -> str:
    if dir is not None and os.path.isdir(dir):
        return dir
    else:
        result = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"], capture_output=True
        )
        if result.returncode == 0:
            flake_dir = os.path.abspath(result.stdout.decode().strip())
            return (
                flake_dir
                if os.path.isfile(os.path.join(flake_dir, "flake.nix"))
                else None
            )


if __name__ == "__main__":
    CURRENT_DIR = os.getcwd()
    IS_COMMIT=True
    DIR = get_flake()
    # IS_COMMIT = os.getenv("_IS_COMMIT")
    # DIR = get_flake(os.path.abspath(os.path.expanduser("~/Workspace/nur-packages")))
    main(DIR)
