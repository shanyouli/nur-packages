with builtins; let
  flake = builtins.getFlake (toString ../.);

  isReserved = n: n == "lib" || n == "overlays" || n == "modules";
  isDerivation = p: isAttrs p && p ? type && p.type == "derivation";
  isBuildable = p: !(p.meta.broken or false) && p.meta.license.free or true;
  isCacheable = p: !(p.preferLocalBuild or false);
  shouldRecurseForDerivations = p: isAttrs p && p.recurseForDerivations or false;

  nameValuePair = n: v: {
    name = n;
    value = v;
  };

  concatMap = builtins.concatMap or (f: xs: concatLists (map f xs));

  flattenPkgs = s: let
    f = p:
      if shouldRecurseForDerivations p
      then flattenPkgs p
      else if isDerivation p
      then [p]
      else [];
  in
    concatMap f (attrValues s);

  outputsOf = p: map (o: p.${o}) p.outputs;

  nurAttrs = flake.currentSystem.packages;
  nurPkgs =
    flattenPkgs
    (listToAttrs
      (map (n: nameValuePair n nurAttrs.${n})
        (filter (n: !isReserved n)
          (attrNames nurAttrs))));
  isPkg' = name: p:
    if builtins.hasAttr name p
    then p.${name}
    else null;
  isPkg = name: isPkg' name nurAttrs;
  devPkgs = flattenPkgs {
    # darwin file --> darwin-apps-xx
    # python file --> python-apps-xx
    # firefox-addons --> firefox-addons-xx

    # airbattery = isPkg "darwin-apps-airbattery";
    p = isPkg "nh_darwin";
  };
in rec {
  buildPkgs = filter isBuildable nurPkgs;
  cachePkgs = filter isCacheable buildPkgs;
  cacheOutputs = concatMap outputsOf cachePkgs;
  bbdownDeps = nurAttrs.bbdown.fetch-deps;
  buildDevPkgs = filter isBuildable devPkgs;
  cacheDevPkgs = filter isCacheable buildDevPkgs;
  cacheDevOutputs = concatMap outputsOf devPkgs;
}
