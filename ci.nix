# This file provides all the buildable and cacheable packages and
# package outputs in your package set. These are what gets built by CI,
# so if you correctly mark packages as
#
# - broken (using `meta.broken`),
# - unfree (using `meta.license.free`), and
# - locally built (using `preferLocalBuild`)
#
# then your CI will be able to build and cache only those packages for
# which this is possible.
{pkgs ? import <nixpkgs> {}}:
with builtins; let
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

  nurAttrs = import ./default.nix {inherit pkgs;};

  nurPkgs =
    flattenPkgs
    (listToAttrs
      (map (n: nameValuePair n nurAttrs.${n})
        (filter (n: !isReserved n)
          (attrNames nurAttrs))));

  firefoxAddons = nurAttrs.firefox-addons;
  nurFirefoxAddons =
    flattenPkgs
    (listToAttrs
      (map (n: nameValuePair n firefoxAddons.${n})
        (filter (n: !isReserved n)
          (attrNames firefoxAddons))));
in rec {
  buildPkgs = filter isBuildable nurPkgs;
  cachePkgs = filter isCacheable buildPkgs;

  buildOutputs = concatMap outputsOf buildPkgs;
  cacheOutputs = concatMap outputsOf cachePkgs;

  firefoxAddonsOutputs = concatMap outputsOf nurFirefoxAddons;
  darwinOutputs =
    if pkgs.stdenvNoCC.isDarwin
    then
      (
        let
          darwinAttrs = nurAttrs.darwinApps;
          nurDarwinPkgs =
            flattenPkgs
            (listToAttrs
              (map (n: nameValuePair n darwinAttrs.${n})
                (filter (n: !isReserved n)
                  (attrNames darwinAttrs))));
          buildDarwinPkgs = filter isBuildable nurDarwinPkgs;
          cacheDarwinPkgs = filter isCacheable buildDarwinPkgs;
        in
          concatMap outputsOf cacheDarwinPkgs
      )
    else [];
}
