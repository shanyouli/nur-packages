{
  self,
  lib,
  inputs,
  ...
}: {
  perSystem = {
    config,
    system,
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

    devShells.default = makeAppsShell apps;
  };
}
