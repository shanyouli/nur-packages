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
"""


def get_packages_only_system(data: dict, system: str) -> bool:
    if len(data) > 2:
        return False
    if system == "darwin":
        return "aarch64-darwin" in data and "x86_64-darwin" in data
    else:
        return "aarch64-linux" in data and "x86_64-linux" in data


def pkg_is_broken(path, name, systems):
    systems_str = " ".join([f'"{i}"' for i in systems])
    nix_script = f"""let flake = builtins.getFlake "{os.path.abspath(path)}";
packages = flake.packages;
isBuildable = p: !(p.meta.broken or false);
packagename = "{name}";

fn = systems: (builtins.listToAttrs (builtins.filter (n: n.value)
      (builtins.map (n: {{name = n; value = ! isBuildable packages."${{n}}"."${{packagename}}";}}) systems)));
result = builtins.attrNames (fn [{systems_str}]);
in builtins.concatStringsSep " " result
"""
    result = subprocess.run(
        f"nix eval --expr '{nix_script}' --impure", capture_output=True, shell=True
    )
    if result.returncode != 0:
        return
    output = result.stdout.decode("utf-8").strip()
    return output if output != '""' else ""


def get_packages_info(p):
    os.chdir(p)
    result = subprocess.run(
        "nix flake show --all-systems --json".split(), capture_output=True
    )
    if result.returncode != 0:
        return
    packages = json.loads(result.stdout.decode("utf-8"))["packages"]
    results = {}
    for k, v in packages.items():
        for n, p in v.items():
            if n in results:
                results[n]["system"].append(k)
            else:
                results[n] = {
                    "desc": p["description"] if "description" in p else "None",
                    "system": [k],
                }
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
        else:
            systems = v["system"]
            if get_packages_only_system(systems, "linux"):
                linux_apps[k] = v
            elif get_packages_only_system(systems, "darwin"):
                darwin_apps[k] = v
            else:
                common[k] = v
    return common, linux_apps, darwin_apps, firefox_addons, py_apps


def show_pacakges(data: dict, typology: str, is_broken: bool) -> str:
    msg = f"### {typology}\n"
    if typology == "common":
        msg += "\nDefault support for *aarch64-linux,aarch64-darwin,x86_64-linux and x86_64-darwin*\n"
    elif typology == "firefox-addons":
        msg += "\n*firefox extension*, default support for all systems that support firefox\n"
    elif typology == "python3-apps":
        msg += "\nInstalling python programs with nix\n"
    elif typology == "linux":
        msg += "\nOnly support for *aarch64-linux*, *x86_64-linux*\n"
    elif typology == "darwin":
        msg += "\nOnly support for *aarch64-darwin*, *x86_64-darwin*, Most gui packages only support aarch64-darwin\n"
    if is_broken:
        msg += """
|name|broken system| description|
|:---|:---|:---|
"""
        msg += "\n".join(
            [
                rf"|`{k.removeprefix('firefox-addons-').removeprefix('python-apps-')}`|{pkg_is_broken(DIR, k, v['system'])}|{v['desc']}|"
                for k, v in data.items()
            ]
        )
    else:
        msg += """
|name| description|
|:---|:---|
"""
        msg += "\n".join(
            [
                rf"|`{k.removeprefix('firefox-addons-').removeprefix('python-apps-')}`|{v['desc']}|"
                for k, v in data.items()
            ]
        )

    return msg


def get_package_show(p) -> str:
    msg = """## packages

Currently only builds on aarch64-darwin and x86_64-linux

"""
    common, linux_apps, darwin_apps, firefox_addons, python3_apps = get_packages_info(p)
    if common:
        msg += show_pacakges(common, typology="common", is_broken=True)
        msg += "\n\n"
    if linux_apps:
        msg += show_pacakges(linux_apps, typology="linux", is_broken=True)
        msg += "\n\n"

    if darwin_apps:
        msg += show_pacakges(darwin_apps, typology="darwin", is_broken=True)
        msg += "\n\n"

    if firefox_addons:
        msg += show_pacakges(firefox_addons, typology="firefox-addons", is_broken=False)
        msg += "\n\n"
    if python3_apps:
        msg += show_pacakges(python3_apps, typology="python3-apps", is_broken=False)
        msg += "\n\n"

    return msg


def main(f):
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
    packages_msg = get_package_show(f)

    with open(
        os.path.join(f, "README.md"), mode="w+", encoding="utf-8"
    ) as f:
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
    os.chdir(f)
    if subprocess.run(["git", "diff", "HEAD^1", "README.md", "|", "grep", "-"]).returncode == 0:
        subprocess.run("git add README.md", shell=True)
        subprocess.run(f"git commit -m 'update README.md {time.strftime('%Y-%m-%d %H:%M:%S %Z')}'", shell=True)

def get_flake(dir: str = None) -> str:
    if dir is not None and os.path.isdir(dir):
        return dir
    else:
        result = subprocess.run(['git', 'rev-parse', '--show-toplevel'], capture_output=True)
        if result.returncode == 0:
            flake_dir = os.path.abspath(result.stdout.decode().strip())
            return  flake_dir if os.path.isfile(os.path.join(flake_dir, 'flake.nix')) else None

if __name__ == "__main__":
    DIR=get_flake()
    # print(DIR)
    main(DIR)
    # a= pkg_is_broken(NIX_FLAKE_DIR, "mihomo", ["aarch64-darwin", "aarch64-linux", "x86_64-linux", "x86_64-darwin"])
    # print(a)
