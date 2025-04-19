{ lib, self, ... }:
let
  inherit (builtins)
    isAttrs
    attrValues
    map
    attrNames
    filter
    concatStringsSep
    ;
  inherit (lib)
    concatMap
    nameValuePair
    listToAttrs
    splitString
    length
    removePrefix
    sublist
    ;
  inherit (self.modules) relativeRoot;
in
rec {
  isReserved = n: n == "lib" || n == "overlays" || n == "modules";
  isDerivation = p: isAttrs p && p ? type && p.type == "derivation";
  isBuildable = p: !(p.meta.broken or false) && p.meta.license.free or true;
  isCacheable = p: !(p.preferLocalBuild or false);
  shouldRecurseForDerivations = p: isAttrs p && p.recurseForDerivations or false;
  flattenPkgs =
    s:
    let
      f =
        p:
        if shouldRecurseForDerivations p then
          flattenPkgs p
        else if isDerivation p then
          [ p ]
        else
          [ ];
    in
    concatMap f (attrValues s);

  nurPkgsFn =
    attrs:
    flattenPkgs (
      listToAttrs (map (n: nameValuePair n attrs.${n}) (filter (n: !(isReserved n)) (attrNames attrs)))
    );

  outputsOf = p: map (o: p.${o}) p.outputs;

  parentDir =
    dir:
    let
      dir-list = splitString "/" dir;
    in
    concatStringsSep "/" (sublist 0 ((length dir-list) - 1) dir-list);

  nurSources =
    p:
    let
      sources = p.callPackages (relativeRoot "_sources/generated.nix") { };
    in
    lib.mapAttrs (
      _: v:
      if !(isAttrs v) then
        v
      else
        let
          removeVersionPrefix = {
            version = removePrefix "v" v.version;
          };
          unstableDateVersion =
            if
              (builtins.hasAttr "version" v)
              && (builtins.match "[0-9a-f]{40}" v.version != null)
              && (builtins.hasAttr "date" v)
            then
              {
                version = "unstable-${v.date}";
                rawVersion = v.version;
              }
            else
              { rawVersion = v.version; };
        in
        lib.foldl lib.recursiveUpdate v [
          removeVersionPrefix
          unstableDateVersion
        ]
    ) sources;
}
