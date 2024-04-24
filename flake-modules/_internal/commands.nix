{
  lib,
  inputs,
  ...
}: {
  perSystem = {
    config,
    pkgs,
    inputs',
    ...
  }: let
    commands = rec {
      ci = ''
        set -euo pipefail

        NIX_LOGFILE=nix-build-uncached.log

        # Workaround https://github.com/NixOS/nix/issues/6572
        for i in {1..5}; do
          ${pkgs.nix-build-uncached}/bin/nix-build-uncached tests/ci.nix -A cacheOutputs -vv -build-flags '-v -L' --show-trace 2>&1 | tee $NIX_LOGFILE && exit 0
          if grep -q "specified:" $NIX_LOGFILE; then
            if grep -q "got:" $NIX_LOGFILE; then
              SAVEIFS=$IFS
              IFS=$'\n'

              SPECIFIED_HASH=($(grep "specified:" $NIX_LOGFILE | cut -d":" -f2 | xargs))
              GOT_HASH=($(grep "got:" $NIX_LOGFILE | cut -d":" -f2 | xargs))

              IFS=$SAVEIFS

              for (( i=0; i<''${#SPECIFIED_HASH[@]}; i++ )); do
                echo "Auto replace ''${SPECIFIED_HASH[$i]} with ''${GOT_HASH[$i]}"
                ${pkgs.gnused}/bin/sed -i "s#''${SPECIFIED_HASH[$i]}#''${GOT_HASH[$i]}#g" $(find pkgs/ -name \*.nix) || true
                SPECIFIED_HASH_OLD=$(nix hash convert --to nix32 "''${SPECIFIED_HASH[$i]}")
                echo "Auto replace ''${SPECIFIED_HASH_OLD} with ''${GOT_HASH[$i]}"
                ${pkgs.gnused}/bin/sed -i "s#''${SPECIFIED_HASH_OLD}#''${GOT_HASH[$i]}#g" $(find pkgs/ -name \*.nix) || true
              done
            fi
          fi
          rm -f $NIX_LOGFILE
        done

        exit 1
      '';
      devci = ''
        set -euo pipefail
        ${pkgs.nix-build-uncached}/bin/nix-build-uncached tests/dev.nix -A cacheDevOutputs -vv -build-flags '-v -L' --show-trace 2>&1
      '';
      nvfetcher = ''
        set -euo pipefail
        keys_args=""
        [[ -f $HOME/.config/nvfetcher.toml ]] && keys_args="-k $HOME/.config/nvfetcher.toml"
        export NIX_PATH="nixpkgs=${inputs.nixpkgs}:''${NIX_PATH:-}"
        export PYTHONPATH=${pkgs.python3Packages.packaging}/lib/python${pkgs.python3.pythonVersion}/site-packages:''${PYTHONPATH:-}
        ${inputs'.nvfetcher.packages.default}/bin/nvfetcher $keys_args -r 10  --keep-going -j 3 --commit-changes
      '';
      bbdownDeps = ''
        set -euo pipefail
        nix-build ./tests/ci.nix -A bbdownDeps -v
        ./result ./pkgs/common/bbdown/deps.nix
        if [[ $(git diff ./pkgs/common/bbdown/deps.nix) != "" ]]; then
          git add ./pkgs/common/bbdown/deps.nix
          git commit -m "update bbdown deps"
        fi
      '';

      updatePy = let
        py = pkgs.python3.withPackages (p: with p; [requests beautifulsoup4]);
      in ''
        find ./pkgs -iname "update.py" | while read -r f; do
          echo "update $(echo "$f" | rev | cut -d'/' -f2 | rev) ..."
          ${py}/bin/python3 "$f" 1
        done
      '';
      upFlake = ''
        set -euo pipefail
        nix flake update
      '';
    };

    makeAppsShell = pkgs.callPackage ../../lib/make-apps-shell.nix {};
  in rec {
    apps =
      lib.mapAttrs (n: v: {
        type = "app";
        program = pkgs.writeShellScriptBin n v;
      })
      commands;

    devShells.default = makeAppsShell {
      inherit apps;
      shellHook = config.pre-commit.installationScript;
      nativeBuildInputs = [config.pre-commit.settings.package];
    };
  };
}
