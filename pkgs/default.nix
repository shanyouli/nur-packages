{pkgs}: let
  hasNixSuffix = str: let
    sLen = builtins.stringLength str;
  in (sLen > 4 && builtins.substring (sLen - 4) sLen str == ".nix");
  removeNixSuffix = str: let
    sLen = builtins.stringLength str;
  in
    if (sLen > 4 && builtins.substring (sLen - 4) sLen str == ".nix")
    then builtins.substring 0 (sLen - 4) str
    else str;

  getAttr = key: attr:
    if (builtins.hasAttr key attr)
    then builtins.getAttr key attr
    else null;
  mapPackages' = dir: fn: namefn:
    with builtins;
      listToAttrs (map (n: {
          name = namefn n;
          value = fn n;
        }) (filter (v:
          v
          != null) (attrValues (mapAttrs (
          k: v:
            if
              (
                (v == "directory" && k != "_sources" && pathExists "${toString dir}/${k}/default.nix")
                || (v == "regular" && hasNixSuffix k && k != "default.nix")
              )
            then k
            else null
        ) (readDir dir)))));
  mapPackages = dir: fn: mapPackages' dir fn removeNixSuffix;

  mapPkgs = dir: callFn: mapPackages dir (name: callFn dir name);
  mapPkgs' = dir: callFn: namefn: mapPackages' dir (name: callFn dir name) namefn;

  darwinNameFn = name: (removeNixSuffix name) + "-app";

  sources = (import ../_sources/generated.nix) {inherit (pkgs) fetchurl fetchFromGitHub fetchgit dockerTools;};
  fsources = builtins.fromJSON (builtins.readFile ./firefox-addons/sources.json);
  mkScope = f:
    builtins.removeAttrs
    (pkgs.lib.makeScope pkgs.newScope (
      self: let
        pkg = self.newScope {
          inherit mkScope;
          sources = self.callPackage ../_sources/generated.nix {};
        };
      in
        f self pkg
    ))
    [
      "newScope"
      "callPackage"
      "overrideScope"
      "overrideScope'"
      "packages"
    ];
in
  mkScope (
    self: pkg: let
      callPkg = dir: name: let
        package = import "${builtins.toString dir}/${name}";
        source = let
          basename = removeNixSuffix name;
          bsource = getAttr basename sources;
        in
          if bsource == null
          then (getAttr basename fsources)
          else bsource;
        args = builtins.intersectAttrs (builtins.functionArgs package) {
          inherit source;
        };
      in
        pkg package args;

      darwinApps =
        if pkgs.stdenvNoCC.isDarwin
        then {darwinApps = mapPkgs ./darwin callPkg;}
        else {};
    in
      rec {}
      // (mapPkgs ./build-support callPkg)
      // (mapPkgs ./common callPkg)
      // {firefox-addons = mapPkgs ./firefox-addons callPkg;}
      // darwinApps
  )
