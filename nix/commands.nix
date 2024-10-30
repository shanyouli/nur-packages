{
  lib,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    inputs',
    system,
    my,
    ...
  }: let
    commands = rec {
      ci = ''
        set -euo pipefail

        NIX_LOGFILE=nix-build-uncached.log

        # Workaround https://github.com/NixOS/nix/issues/6572
        __IS_NEXT=true
        TRY_NUM=0
        while [[ "''${__IS_NEXT}" == "true" ]]; do
          __IS_NEXT=false
          TRY_NUM=$(( TRY_NUM + 1 ))
          echo "::group::Try $TRY_NUM: Building packages with nix-fast-build"
          ${pkgs.nix-fast-build}/bin/nix-fast-build -f .#packages.${system} --skip-cached --no-nom 2>&1 | tee $NIX_LOGFILE && exit 0
          echo "::endgroup::"

          if grep -q "specified:" $NIX_LOGFILE; then
            if grep -q "got:" $NIX_LOGFILE; then
              SPECIFIED_HASH=($(grep "specified:" $NIX_LOGFILE | cut -d":" -f2 | xargs))
              GOT_HASH=($(grep "got:" $NIX_LOGFILE | cut -d":" -f2 | xargs))

              for (( i=0; i<''${#SPECIFIED_HASH[@]}; i++ )); do
                __IS_NEXT=true
                echo "::group::Auto replace ''${SPECIFIED_HASH[@]:$i:1} with ''${GOT_HASH[@]:$i:1}"
                echo "Auto replace ''${SPECIFIED_HASH[@]:$i:1} with ''${GOT_HASH[@]:$i:1}"
                ${pkgs.gnused}/bin/sed -i "s#''${SPECIFIED_HASH[@]:$i:1}#''${GOT_HASH[@]:$i:1}#g" $(find pkgs/ -name \*.nix) || true
                echo "::endgroup::"

                SPECIFIED_HASH_OLD=$(nix hash convert --to nix32 "''${SPECIFIED_HASH[@]:$i:1}" || nix hash to-base32 "''${SPECIFIED_HASH[@]:$i:1}")
                echo "::group::Auto replace ''${SPECIFIED_HASH_OLD} with ''${GOT_HASH[@]:$i:1}"
                echo "Auto replace ''${SPECIFIED_HASH_OLD} with ''${GOT_HASH[@]:$i:1}"
                ${pkgs.gnused}/bin/sed -i "s#''${SPECIFIED_HASH_OLD}#''${GOT_HASH[@]:$i:1}#g" $(find pkgs/ -name \*.nix) || true
                echo "::endgroup::"
              done
            fi
          fi
          rm -f $NIX_LOGFILE
        done

        exit 1
      '';
      devci = ''
        set -euo pipefail
        NIX_LOGFILE=nix-build-uncached.log
        for i in {1..5}; do
          ${pkgs.nix-build-uncached}/bin/nix-build-uncached tests/dev.nix -A cacheDevOutputs -vv -build-flags '-v -L' --show-trace 2>&1 | tee $NIX_LOGFILE && exit 0
          if grep -q "specified:" $NIX_LOGFILE; then
            if grep -q "got:" $NIX_LOGFILE; then
              SPECIFIED_HASH=($(grep "specified:" $NIX_LOGFILE | cut -d":" -f2 | xargs))
              GOT_HASH=($(grep "got:" $NIX_LOGFILE | cut -d":" -f2 | xargs))
              for (( i=0; i<''${#SPECIFIED_HASH[@]}; i++ )); do
                echo "::group::Auto replace ''${SPECIFIED_HASH[@]:$i:1} with ''${GOT_HASH[@]:$i:1}"
                echo "Auto replace ''${SPECIFIED_HASH[@]:$i:1} with ''${GOT_HASH[@]:$i:1}"
                ${pkgs.gnused}/bin/sed -i "s#''${SPECIFIED_HASH[@]:$i:1}#''${GOT_HASH[@]:$i:1}#g" $(find pkgs/ -name \*.nix) || true
                echo "::endgroup::"

                SPECIFIED_HASH_OLD=$(nix hash convert --to nix32 "''${SPECIFIED_HASH[@]:$i:1}" || nix hash to-base32 "''${SPECIFIED_HASH[@]:$i:1}")
                echo "::group::Auto replace ''${SPECIFIED_HASH_OLD} with ''${GOT_HASH[@]:$i:1}"
                echo "Auto replace ''${SPECIFIED_HASH_OLD} with ''${GOT_HASH[@]:$i:1}"
                ${pkgs.gnused}/bin/sed -i "s#''${SPECIFIED_HASH_OLD}#''${GOT_HASH[@]:$i:1}#g" $(find pkgs/ -name \*.nix) || true
                echo "::endgroup::"
              done
            fi
          else
            __IS_NEXT=false
          fi
          rm -f $NIX_LOGFILE
        done
        exit 1
      '';
    };
    nushell-commands = rec {
      nvfetcher = ''
        use std log
        log info $"The execution file path is ($env.FILE_PWD)"
        exit 0
        mut key_args = [ "-r" "10" "--keep-going" "-j" "3" "--commit-changes"]
        let nvfetcher_config = $env.HOME | path join ".config" "nvfetcher.toml"
        let ccommit = git rev-parse --short=7 HEAD
        if ($nvfetcher_config | path exists) {
          $key_args = $key_args | append "-k"
          $key_args = $key_args | append $nvfetcher_config
        }
        let nix_path = "nixpkgs=${inputs.nixpkgs}" + (if ($env | get -i NIX_PATH | is-empty) {
            ""
            } else {
             ":" + $env.NIX_PATH
            })
        let pythonpath = "${pkgs.python3Packages.packaging}/lib/python${pkgs.python3.pythonVersion}/site-packages" + (
           if ($env | get -i PYTHONPATH | is-empty) {
             ""
           } else {
             ":" + $env.PYTHONPATH
           })
        with-env {PYTHONPATH: $pythonpath, NIX_PATH: $nix_path } {
          print $"::group::(ansi green_underline)Update source by nvfetcher(ansi reset)..."
          ${inputs'.nvfetcher.packages.default}/bin/nvfetcher $keys_args -r 10  --keep-going -j 3 --commit-changes
          print "::endgroup::"
        }
        if ((git re-parse --short=7 HEAD) != $ccommit) {
          if (git log HEAD^..HEAD | str contains bbdown) {
            print $"::group::(ansi green_underline)create bbdown deps update script(ansi reset)..."
            ${pkgs.nix-fast-build}/bin/nix-fast-build -f .#packages.${system}.bbdown.fetch-deps --skip-cached --no-nom
            print "::endgroup::"
            print $"::group::(ansi green_underline)update bbdown deps(ansi reset)..."
            if ("./result-" | path exists ) {
              ./result- ./pkgs/common/bbdown/deps.nix
            } else if ("./result" | path exists ) {
              ./result ./pkgs/common/bbdown/deps.nix
            }
            print "::endgroup::"
          }
          print "::group::commit bbdown deps"
          if ((git diff ./pkgs/common/bbdown/deps.nix) != "") {
            git add ./pkgs/common/bbdown/deps.nix
            git commit -m "update bbdown deps"
          }
          print "::endgroup::"
        }
      '';
      upFlake = ''
        nix flake update
      '';
      readme = ''
        ${pkgs.python3}/bin/python3 ./tools/write_readme.py
      '';
      updatePy = let
        py = pkgs.python3.withPackages (p: with p; [requests beautifulsoup4]);
      in ''
        for i in (^find ./pkgs -name "update.py" | lines ) {
          print $"::group::(ansi green_underline)Update ($i | path dirname  | path basename)(ansi reset)..."
          ${py}/bin/python3 $i 1
          print "::endgroup::"
        }
      '';
    };
  in rec {
    apps =
      (lib.mapAttrs (n: v: {
          type = "app";
          program = pkgs.writeShellScriptBin n v;
        })
        commands)
      // (lib.mapAttrs (n: v: {
          type = "app";
          program = my.writeNuScriptBin n v;
        })
        nushell-commands);
  };
}
