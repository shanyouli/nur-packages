{lib, ...}: let
  inherit (builtins) isAttrs attrValues map attrNames filter;
  inherit (lib) concatMap nameValuePair listToAttrs;
in rec {
  isReserved = n: n == "lib" || n == "overlays" || n == "modules";
  isDerivation = p: isAttrs p && p ? type && p.type == "derivation";
  isBuildable = p: !(p.meta.broken or false) && p.meta.license.free or true;
  isCacheable = p: !(p.preferLocalBuild or false);
  shouldRecurseForDerivations = p: isAttrs p && p.recurseForDerivations or false;
  flattenPkgs = s: let
    f = p:
      if shouldRecurseForDerivations p
      then flattenPkgs p
      else if isDerivation p
      then [p]
      else [];
  in
    concatMap f (attrValues s);

  nurPkgsFn = attrs:
    flattenPkgs (listToAttrs (map (n: nameValuePair n attrs.${n})
        (filter (n: !(isReserved n)) (attrNames attrs))));

  outputsOf = p: map (o: p.${o}) p.outputs;
}
