with builtins; let
  flake = builtins.getFlake (toString ../.);
  inherit (flake.lib) isBuildable isCacheable flattenPkgs outputsOf;

  nurAttrs = flake.currentSystem.packages;

  isPkg' = name: p:
    if builtins.hasAttr name p
    then p.${name}
    else null;

  isPkg = name: isPkg' name nurAttrs;

  devPkgs = flattenPkgs {
    # darwin file --> darwin-apps-xx
    # python file --> python-apps-xx
    # firefox-addons --> firefox-addons-xx
    # fish file -> fish-xx

    p = isPkg "darwin-apps-nowplaying-cli";
    # a = isPkg "alist";
  };
in rec {
  buildDevPkgs = filter isBuildable devPkgs;
  cacheDevPkgs = filter isCacheable buildDevPkgs;
  cacheDevOutputs = concatMap outputsOf devPkgs;
}
