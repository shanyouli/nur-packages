{
  mkShell,
  lib,
  writeShellScriptBin,
  ...
}: {
  apps,
  shellHook ? "",
  nativeBuildInputs ? [],
  ...
}:
mkShell {
  inherit nativeBuildInputs shellHook;
  buildInputs = lib.mapAttrsToList (n: v:
    writeShellScriptBin n ''
      exec nix run .#{n} -- "$@"
    '')
  apps;
}
