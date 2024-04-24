{
  lib,
  system,
  ...
}: rec {
  isDerivation = p: builtins.isAttrs p && p ? type && p.type == "derivation";
  isHiddenName = n: lib.hasPrefix "_" n || n == "stdenv";
  isTargetPlatform = p: lib.elem system (p.meta.platforms or [system]);
  isBuildable = p: !(p.meta.broken or false) && p.meta.license.free or true;
  isCacheable = p: !(p.preferLocalBuild or false);
  shouldRecurseForDerivations = p: lib.isAttrs p && p.recurseForDerivations or false;

  _flattenPkgs = prefix: sep: s:
    builtins.filter ({
      name ? null,
      value ? null,
    }:
      name != null && value != null)
    (
      lib.flatten (
        lib.mapAttrsToList (
          n: p: let
            path =
              if prefix != ""
              then "${prefix}${sep}${n}"
              else n;
          in
            if isHiddenName n
            then []
            else if !(builtins.tryEval p).success
            then []
            else if shouldRecurseForDerivations p
            then _flattenPkgs path sep p
            else if isTargetPlatform p
            then [
              {
                name = path;
                value = p;
              }
            ]
            else []
        )
        s
      )
    );
  flattenPkgs' = prefix: sep: s: lib.listToAttrs (_flattenPkgs prefix sep s);
  flattenPkgs = flattenPkgs' "" "-";
}
