{
  mkShell,
  lib,
  writeShellScriptBin,
  ...
}: {apps, ...} @ extra: let
  _buildInputs =
    (lib.mapAttrsToList (n: v:
      writeShellScriptBin n ''
        exec nix run .#${n} -- "$@"
      '')
    apps)
    ++ lib.optionals (extra ? buildInputs) extra.buildInputs;
  _extra =
    (lib.removeAttrs extra ["buildInputs" "apps"])
    // {
      buildInputs = _buildInputs;
    };
in
  mkShell _extra
