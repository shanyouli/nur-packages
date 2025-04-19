{ inputs, ... }:
{
  perSystem =
    {
      config,
      lib,
      my,
      self',
      pkgs,
      ...
    }:
    {
      devShells.default = my.make-apps-shell {
        inherit (self') apps;
        name = "Shanyou Li";
        meta.description = "nix development environment";
        inputsFrom = lib.optionals (inputs ? treefmt-nix) [ config.treefmt.build.programs ];
        nativeBuildInputs =
          let
            pre-commitPackags =
              if (inputs ? git-hooks-nix) then
                with config.pre-commit; settings.enabledPackages ++ [ settings.package ]
              else
                [ ];
          in
          pre-commitPackags;
        # how to work on vscode, see https://github.com/numtide/treefmt-nix/issues/329
        shellHook =
          ''
            FLAKE_ROOT=$(${lib.getExe pkgs.gitMinimal} rev-parse --show-toplevel)
            SYMLINK_SOURCE_PATH="${config.treefmt.build.configFile}"
            SYMLINK_TARGET_PATH="$FLAKE_ROOT/.treefmt.toml"

            if [[ -e "$SYMLINK_TARGET_PATH" && ! -L "$SYMLINK_TARGET_PATH" ]]; then
              echo "treefmt-nix: Error: Target exists but is not a symlink."
              exit 1
            fi

            if [[ -L "$SYMLINK_TARGET_PATH" ]]; then
              if [[ "$(readlink "$SYMLINK_TARGET_PATH")" != "$SYMLINK_SOURCE_PATH" ]]; then
                echo "treefmt-nix: Removing existing symlink"
                unlink "$SYMLINK_TARGET_PATH"
              else
                exit 0
              fi
            fi

            nix-store --add-root "$SYMLINK_TARGET_PATH" --indirect --realise "$SYMLINK_SOURCE_PATH"
            echo "treefmt-nix: Created symlink successfully"
          ''
          + lib.optionalString (inputs ? git-hooks-nix) config.pre-commit.settings.installationScript;
      };
    };
}
