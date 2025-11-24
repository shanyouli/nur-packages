{
  lib,
  inputs,
  self,
  ...
}:
let
  inherit (self.lib)
    mapModules
    relativeRoot
    nurSources
    parentDir
    mapModules'
    ;

  pkgsPath = relativeRoot "pkgs";
  pkgsSubPath = dirname: (pkgsPath + "/${dirname}");

  mapPkgs = pathName: fn: mapModules (pkgsSubPath pathName) fn;
  mapPkgs' = pathName: fn: mapModules' (pkgsSubPath pathName) fn;

  pkgOverlays =
    final: prev:
    let
      sources = nurSources final;
      sourceFn =
        dir: basename:
        let
          csourceDir = if lib.pathIsDirectory dir then dir else parentDir dir;
        in
        if builtins.pathExists (csourceDir + "/sources.json") then
          (
            let
              cjson = builtins.fromJSON (builtins.readFile (csourceDir + "/sources.json"));
            in
            if builtins.hasAttr basename cjson then
              (
                let
                  cattrs = builtins.getAttr basename cjson;
                in
                {
                  inherit (cattrs) pname version;
                  src = final.fetchurl { inherit (cattrs) url sha256; };
                }
              )
            else
              lib.getAttr basename sources
          )
        else
          lib.getAttr basename sources;

      callPkg' =
        { dir, name, ... }@extraArgs:
        let
          package = import dir;
          source = sourceFn dir name;
          args = builtins.intersectAttrs (builtins.functionArgs package) (
            lib.removeAttrs extraArgs [
              "dir"
              "name"
            ]
            // {
              inherit sources source;
            }
          );
        in
        final.callPackage package args;
      callPkg = name: dir: callPkg' { inherit dir name; };

      callFishPkg =
        name: dir:
        callPkg' {
          inherit dir name;
          inherit (prev.fishPlugins) buildFishPlugin fishtape_3 fishtape;
        };

      # python overlays
      # @see https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md
      pyPackageOverrides =
        pfinal: pprev:
        let
          callPyPkg =
            name: dir:
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
            propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pfinal.packaging ];
          });
        }
        // mapPkgs "python" callPyPkg;

      # see @https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/lua.section.md#how-to-override-a-lua-package-using-overlays-how-to-override-a-lua-package-using-overlays
      lua-overlay =
        let
          nameAndPkgs = name: pkgs: {
            interpreter = name;
            packages = pkgs;
          };
          luaNames = [
            (nameAndPkgs "lua" "luaPackages")
            (nameAndPkgs "lua5_1" "lua51Packages")
            (nameAndPkgs "lua5_2" "lua52Packages")
            (nameAndPkgs "lua5_3" "lua53Packages")
            (nameAndPkgs "lua5_4" "lua54Packages")
            (nameAndPkgs "luajit" "luajitPackages")
          ];
          overriddenLua =
            { interpreter, packages }:
            let

              newLua = prev.${interpreter}.override {
                packageOverrides =
                  lua_final: lua_prev:
                  let
                    callLuaPkg =
                      name: dir:
                      callPkg' {
                        inherit name dir;
                        lua = prev.${interpreter};
                        luaPackages = lua_final;
                      };
                  in
                  mapPkgs "lua" callLuaPkg;
              };
            in
            [
              {
                name = interpreter;
                value = newLua;
              }
              {
                name = packages;
                value = newLua.pkgs;
              }
            ];
          overriddenLuas = lib.concatMap overriddenLua luaNames;
        in
        builtins.listToAttrs overriddenLuas;

    in
    rec {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        # (python-final: python-prev: {
        #   foo = python-prev.foo.overrPythonAttrs (oldAttrs: {});
        # })
        pyPackageOverrides
      ];
    }
    // (mapModules ./plib/build-support callPkg)
    // lua-overlay
    // {
      inherit (prev.extend inputs.cl-nix-lite.overlays.default) lispPackagesLite;
    }
    // (mapPkgs "common" callPkg)
    // {
      firefox-addons = mapPkgs "firefox-addons" callPkg;
      darwinapps = mapPkgs "darwin" callPkg;
      fishPlugins = mapPkgs "fish" callFishPkg;
    };

  packageFn =
    p:
    let
      darwinPkgs =
        if p.stdenvNoCC.isDarwin then
          mapPkgs' "darwin" (n: _: lib.nameValuePair "darwin-apps-${n}" p.darwinapps.${n})
        else
          { };
    in
    (mapPkgs "common" (n: _: p.${n}))
    // (mapPkgs' "fish" (n: _: lib.nameValuePair "fish-${n}" p.fishPlugins.${n}))
    // (mapPkgs' "firefox-addons" (n: _: lib.nameValuePair "firefox-addons-${n}" p.firefox-addons.${n}))
    // darwinPkgs
    // (mapPkgs' "python" (n: _: lib.nameValuePair "python-apps-${n}" p.python3.pkgs.${n}))
    // (mapPkgs' "lua" (n: _: lib.nameValuePair "lua-apps-${n}" p.lua54Packages.${n}));
in
{
  flake = {
    overlay = self.overlays.default;
    overlays = {
      default = pkgOverlays;
    };
  };
  perSystem =
    { system, pkgs, ... }:
    rec {
      _module.args.pkgs = import inputs.nixpkgs {
        overlays = [ self.overlays.default ];
        inherit system;
        config.allowUnfree = true;
      };
      packages = lib.filterAttrs (_: v: self.lib.isBuildable v) (packageFn pkgs);
    };
}
