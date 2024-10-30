{withSystem, ...}: {
  flake.overlays.nix-index = _final: prev:
    withSystem prev.stdenv.hostPlatform.system ({config, ...}: {
      inherit (config.packages) nix-index;
    });

  perSystem = {
    inputs',
    pkgs,
    ...
  }: let
    nix-index-pkg = inputs'.nix-index-database.packages.default;
  in {
    apps.search-lib = {
      type = "app";
      program = pkgs.writeScriptBin "search-lib" ''
        ${nix-index-pkg}/bin/nix-locate -w "$@" | grep -v "("
      '';
    };
    packages.nix-index = nix-index-pkg;
  };
}
