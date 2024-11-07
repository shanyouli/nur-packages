{
  lib,
  inputs,
  self,
  ...
}: let
  inherit (self.lib) mapModules relativeRoot nurSources parentDir mapModules';

  pkgsPath = relativeRoot "pkgs";
  pkgsSubPath = dirname: (pkgsPath + "/${dirname}");

  mapPkgs = pathName: fn: mapModules (pkgsSubPath pathName) fn;
  mapPkgs' = pathName: fn: mapModules' (pkgsSubPath pathName) fn;

  pkgOverlays = final: prev: let
    sources = nurSources final;
    sourceFn = dir: basename: let
      csourceDir =
        if lib.pathIsDirectory dir
        then dir
        else parentDir dir;
    in
      if builtins.pathExists (csourceDir + "/sources.json")
      then
        (let
          cjson = builtins.fromJSON (builtins.readFile (csourceDir + "/sources.json"));
        in
          if builtins.hasAttr basename cjson
          then
            (let
              cattrs = builtins.getAttr basename cjson;
            in {
              inherit (cattrs) pname version;
              src = final.fetchurl {inherit (cattrs) url sha256;};
            })
          else lib.getAttr basename sources)
      else lib.getAttr basename sources;

    callPkg' = {
      dir,
      name,
      ...
    } @ extraArgs: let
      package = import dir;
      source = sourceFn dir name;
      args = builtins.intersectAttrs (builtins.functionArgs package) (lib.removeAttrs extraArgs ["dir" "name"]
        // {
          inherit sources source;
        });
    in
      final.callPackage package args;
    callPkg = name: dir: callPkg' {inherit dir name;};

    callFishPkg = name: dir:
      callPkg' {
        inherit dir name;
        inherit (prev.fishPlugins) buildFishPlugin fishtape_3 fishtape;
      };

    packageOverrides = pfinal: pprev: let
      callPyPkg = name: dir:
        pfinal.toPythonModule (callPkg' {
          inherit name dir;
          python3Packages = pfinal;
        });
    in
      {
        # httpx = pprev.httpx.overrideAttrs (old: {
        #   inherit (sources.httpx) pname version src;
        # });
        dict2xml = pprev.dict2xml.overrideAttrs (_old: {
          inherit (sources.dict2xml) pname version src;
        });
        # nvfetcher-bin neeed packaging
        nvchecker = pprev.nvchecker.overrideAttrs (old: {
          propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [pfinal.packaging];
        });
      }
      // mapPkgs "python" callPyPkg;
  in
    rec {
      python3 = prev.python3.override {inherit packageOverrides;};
      python3Packages = python3.pkgs;

      pypy3 = prev.python3.override {inherit packageOverrides;};
      pypy3Packages = pypy3.pkgs;

      python39 = prev.python39.override {inherit packageOverrides;};
      python39Packages = python39.pkgs;

      python310 = prev.python310.override {inherit packageOverrides;};
      python310Packages = python310.pkgs;
    }
    // (mapModules ./plib/build-support callPkg)
    // (mapPkgs "common" callPkg)
    // {
      firefox-addons = mapPkgs "firefox-addons" callPkg;
      darwinapps = mapPkgs "darwin" callPkg;
      qbittorrent-enhanced-nox = final.qbittorrent-enhanced.override {guiSupport = false;};
      fishPlugins = mapPkgs "fish" callFishPkg;
    };
  packageFn = p: let
    darwinPkgs =
      if p.stdenvNoCC.isDarwin
      then mapPkgs' "darwin" (n: _: lib.nameValuePair "darwin-apps-${n}" p.darwinapps.${n})
      else {};
  in
    (mapPkgs "common" (n: _: p.${n}))
    // (mapPkgs' "fish" (n: _: lib.nameValuePair "fish-${n}" p.fishPlugins.${n}))
    // (mapPkgs' "firefox-addons" (n: _: lib.nameValuePair "firefox-addons-${n}" p.firefox-addons.${n}))
    // darwinPkgs
    // {
      inherit (p) qbittorrent-enhanced-nox;
    }
    // (mapPkgs' "python" (n: _: lib.nameValuePair "python-apps-${n}" p.python3.pkgs.${n}));
in {
  flake = {
    overlay = self.overlays.default;
    overlays = {
      default = pkgOverlays;
    };
  };
  perSystem = {
    system,
    pkgs,
    ...
  }: rec {
    _module.args.pkgs = import inputs.nixpkgs {
      overlays = [self.overlays.default];
      inherit system;
      config.allowUnfree = true;
    };
    packages = packageFn pkgs;
  };
}
