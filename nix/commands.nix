{ lib, inputs, ... }:
{
  perSystem =
    {
      pkgs,
      inputs',
      system,
      my,
      config,
      ...
    }:
    let
      commands = rec {
        ci = ''
          const NIX_LOGFILE = "nix-build-uncached.log"
          # Workaround https://github.com/NixOS/nix/issues/6572

          def nixVersion>= [v: string]: nothing -> bool {
            let currentVersion = nix --version | cut -d" " -f3 | split row "."
            let vList = $v | split row "."
            for i in 0..($vList | length) {
              if (($currentVersion | get $i) >= ($vList | get $i)) {
                return true
              }
            }
            return false
          }

          mut is_next = "true"
          mut try_num = 0
          while ($is_next == "true") {
            $is_next = "false"
            $try_num = $try_num + 1
            print $"::group::Try (ansi u)($try_num)(ansi reset): Building packages with nix-fast-build"
            ${pkgs.nix-fast-build}/bin/nix-fast-build -f .#packages.${system} --skip-cached --no-nom out+err>| tee {save -f $NIX_LOGFILE}
            print "::endgroup::"
            let last_10 = ^tail -n 200 $NIX_LOGFILE | decode utf8 | into string
            if (not ($last_10 | parse -r 'ERROR:nix_fast_build:Failed' | is-empty)) {
              print $"nix-fast-build ocommands error, Will check HASH"
              let SPECIFIED_HASH = (grep "specified:" $NIX_LOGFILE | cut -d":" -f2 | lines | str trim )
              if ($SPECIFIED_HASH | is-empty) {
                print $"Please check the script for problems, non-hash errors"
                # rm -rf $NIX_LOGFILE
                exit 1
              }
              let GOT_HASH = (grep "got:" $NIX_LOGFILE | cut -d":" -f2 | lines | str trim)
              for i in 0..(($SPECIFIED_HASH | length) - 1) {
                let old_hash = $SPECIFIED_HASH | get $i
                let new_hash = $GOT_HASH | get $i
                let old_hashx = (if (nixVersion>= 2.20.0) {
                      nix hash convert --to nix32 $old_hash
                    } else {
                      nix hash to-base32 $old_hash
                    })
                print $"::group::Auto replace ($old_hash) with ($new_hash)"
                for f in (^find pkgs -name "*.nix" | lines) {
                  if (open $f | str contains $old_hash) {
                    ${pkgs.gnused}/bin/sed -i $"s#($old_hash)#($new_hash)#g" $f
                  } else if (open $f | str contains $old_hashx) {
                    ${pkgs.gnused}/bin/sed -i $"s#($old_hashx)#($new_hash)#g" $f
                  }
                }
                print "::endgroup::"
              }
              rm -f $NIX_LOGFILE
              $is_next = "true"
            }
          }
        '';
        devci = ''
          let DEFAULT_APPS = ${my.toNu (builtins.attrNames config.packages)}
          let dev_apps = open ./tests/dev.yaml
          if (not ($dev_apps | get dev)) {
            print $"No need to build dev packages."
            exit 0
          }
          let dev_apps = $dev_apps | get apps | filter {|x| $x in $DEFAULT_APPS}
          const NIX_LOGFILE = "nix-build-uncached.log"
          def nixVersion>= [v: string]: nothing -> bool  {
            let currentVersion = nix --version | cut -d" " -f3 | split row "."
            let vList = $v | split row "."
            for i in 0..($vList | length) {
              if (($currentVersion | get $i) >= ($vList | get $i)) {
                return true
              }
            }
            return false
          }
          def build [s: string ] {
            print $"::group::Building (ansi u)($s)(ansi reset) package with nix-fast-build"
            ${pkgs.nix-fast-build}/bin/nix-fast-build -f .#packages.${system}.($s) --skip-cached --no-nom out+err>| tee {save -f $NIX_LOGFILE}
            print $"::endgroup::"
            let last_10 = ^tail -n 200 $NIX_LOGFILE | decode utf8 | into string
            if (not ($last_10 | parse -r 'ERROR:nix_fast_build:Failed' | is-empty)) {
              let SPECIFIED_HASH = (grep "specified:" $NIX_LOGFILE | cut -d":" -f2 | lines | str trim )
              if ($SPECIFIED_HASH | is-empty) {
                print $"Please check the script for problems, non-hash errors"
                rm -rf $NIX_LOGFILE
                exit 1
              }
              let GOT_HASH = (grep "got:" $NIX_LOGFILE | cut -d":" -f2 | lines | str trim)
              for i in 0..(($SPECIFIED_HASH | length) - 1) {
                let old_hash = $SPECIFIED_HASH | get $i
                let new_hash = $GOT_HASH | get $i
                let old_hashx = (if (nixVersion>= 2.20.0) {
                      nix hash convert --to nix32 $old_hash
                    } else {
                      nix hash to-base32 $old_hash
                    })
                print $"::group::Auto replace ($old_hash) with ($new_hash)"
                for f in (^find pkgs -name "*.nix" | lines) {
                  if (open $f | str contains $old_hash) {
                    ${pkgs.gnused}/bin/sed -i $"s#($old_hash)#($new_hash)#g" $f
                  } else if (open $f | str contains $old_hashx) {
                    ${pkgs.gnused}/bin/sed -i $"s#($old_hashx)#($new_hash)#g" $f
                  }
                }
                print "::endgroup::"
              }
              rm -f $NIX_LOGFILE
              false
            } else {
              true
            }
          }
          for i in $dev_apps {
            for j in 1..3 {
              if (build $i) {
                break
              }
            }
          }
        '';
        nvfetcher =
          let
            #see @https://discourse.nixos.org/t/what-does-error-x-is-not-allowed-to-refer-to-the-following-paths-mean-exactly/50680
            # nvfetcher_bin = with pkgs.haskell.lib;
            #   overrideCabal
            #   (justStaticExecutables inputs'.nvfetcher.packages.nvfetcher-lib)
            #   (drv: {
            #     disallowGhcReference = false;
            #   });
            nvfetcher_bin = inputs'.nvfetcher.packages.default;
          in
          ''
            use std log
            log info $"The execution file path is ($env.FILE_PWD)"
            let base_key_args = [ "-r" "10"  "--keep-going" "-j" "3" "--commit-changes"]
            let nvfetcher_config = $env.HOME | path join ".config" "nvfetcher.toml"
            let ccommit = git rev-parse --short=7 HEAD
            let key_args =         if ($nvfetcher_config | path exists) {
              $base_key_args | append "-k" | append $nvfetcher_config
            } else if (($env.PWD | path join "secrets.toml") | path exists) {
              $base_key_args | append "-k" | append ($env.PWD | path join "secrets.toml")
            } else {
              $base_key_args
            }
            let nix_path = "nixpkgs=${inputs.nixpkgs}" + (if ($env | get -o NIX_PATH | is-empty) {
                ""
                } else {
                 ":" + $env.NIX_PATH
                })
            let pythonpath = "${pkgs.python3Packages.packaging}/lib/python${pkgs.python3.pythonVersion}/site-packages" + (
               if ($env | get -o PYTHONPATH | is-empty) {
                 ""
               } else {
                 ":" + $env.PYTHONPATH
               })
            with-env {PYTHONPATH: $pythonpath, NIX_PATH: $nix_path } {
              print $"::group::(ansi green_underline)Update source by nvfetcher(ansi reset)..."
              print $env.PWD
              print ...$key_args
              ${nvfetcher_bin}/bin/nvfetcher ...$key_args -c nvfetcher.toml -o _sources
              print "::endgroup::"
            }
            if ((git rev-parse --short=7 HEAD) != $ccommit) {
              if (git log HEAD^..HEAD | str contains bbdown) {
                print $"::group::(ansi green_underline)create bbdown deps update script(ansi reset)..."
                ${pkgs.nix-fast-build}/bin/nix-fast-build -f .#packages.${system}.bbdown.fetch-deps --skip-cached --no-nom
                print "::endgroup::"
                print $"::group::(ansi green_underline)update bbdown deps(ansi reset)..."
                if ("./result-" | path exists ) {
                  ./result- ./pkgs/common/bbdown/deps.json
                } else if ("./result" | path exists ) {
                  ./result ./pkgs/common/bbdown/deps.json
                }
                # fix some error see: @https://github.com/NixOS/nixpkgs/pull/343837
                ${pkgs.python3}/bin/python3 ./tools/patch-dotnet-deps.py ./pkgs/common/bbdown/deps.json
                print "::endgroup::"
              }
              print "::group::commit bbdown deps"
              if ((git diff ./pkgs/common/bbdown/deps.json) != "") {
                git add ./pkgs/common/bbdown/deps.json
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
        updatePy =
          let
            py = pkgs.python3.withPackages (
              p: with p; [
                requests
                beautifulsoup4
              ]
            );
          in
          ''
            for i in (^find ./pkgs -name "update.py" | lines ) {
              print $"::group::(ansi green_underline)Update ($i | path dirname  | path basename)(ansi reset)..."
              ${py}/bin/python3 $i 1
              print "::endgroup::"
            }
          '';
      };
    in
    rec {
      apps = lib.mapAttrs (n: v: {
        type = "app";
        program = my.writeNuScriptBin n v;
      }) commands;
    };
}
