{ lib, inputs, ... }: {
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
          use ${../tools/utils.nu} *
          # 为 tools/utils.nu 的公共函数前置固定的 nix-fast-build / gnused
          $env.PATH = ([${pkgs.nix-fast-build}/bin ${pkgs.gnused}/bin] ++ $env.PATH)

          const NIX_LOGFILE = "nix-build-uncached.log"
          # Workaround https://github.com/NixOS/nix/issues/6572

          mut is_next = "true"
          mut try_num = 0
          while ($is_next == "true") {
            $is_next = "false"
            $try_num = $try_num + 1
            print $"::group::Try (ansi u)($try_num)(ansi reset): Building packages with nix-fast-build"
            let exit_code = (run-build ${system} $NIX_LOGFILE)
            print "::endgroup::"
            if ($exit_code != 0) {
              fix-hashes $NIX_LOGFILE $exit_code
              $is_next = "true"
            }
          }
        '';
        devci = ''
          use ${../tools/utils.nu} *
          # 为 tools/utils.nu 的公共函数前置固定的 nix-fast-build / gnused
          $env.PATH = ([${pkgs.nix-fast-build}/bin ${pkgs.gnused}/bin] ++ $env.PATH)

          let DEFAULT_APPS = ${my.toNu (builtins.attrNames config.packages)}
          let dev_apps = open ./tests/dev.yaml
          if (not ($dev_apps | get dev)) {
            print $"No need to build dev packages."
            exit 0
          }
          let dev_apps = $dev_apps | get apps | where {|x| $x in $DEFAULT_APPS}
          const NIX_LOGFILE = "nix-build-uncached.log"

          def build [s: string] {
            print $"::group::Building (ansi u)($s)(ansi reset) package with nix-fast-build"
            let exit_code = (run-build ${system} $NIX_LOGFILE --pkg $s --debug)
            print "::endgroup::"
            if ($exit_code != 0) {
              fix-hashes $NIX_LOGFILE $exit_code
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
          '';
        upFlake = ''
          nix flake update
        '';
        readme = ''
          ${pkgs.python3}/bin/python3 ./tools/write_readme.py
        '';
        stopDev = ''
          const P = ./tests/dev.yaml
          let p_info = open $P
          if $p_info.dev {
            $p_info | update dev false | save -f $P
          }
        '';
        updatePy =
          # update.py 均只依赖 python 内置库（urllib 等），无需 withPackages
          let
            py = pkgs.python3;
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
