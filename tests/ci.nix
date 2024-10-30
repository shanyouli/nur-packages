with builtins; let
  flake = builtins.getFlake (toString ../.);
  inherit (flake.lib) isBuildable isCacheable outputsOf nurPkgsFn;

  nurAttrs = flake.currentSystem.packages;
  nurPkgs = nurPkgsFn nurAttrs;
in rec {
  buildPkgs = filter isBuildable nurPkgs;
  cachePkgs = filter isCacheable buildPkgs;
  cacheOutputs = concatMap outputsOf cachePkgs;
  bbdownDeps = nurAttrs.bbdown.fetch-deps;
}
