let
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
in rec {
  overlay = final: prev: let
    sources = (import ../_sources/generated.nix) {inherit (final) fetchurl fetchFromGitHub fetchgit dockerTools;};
    fsources = builtins.fromJSON (builtins.readFile ./firefox-addons/sources.json);

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
        inherit sources source;
      };
    in
      final.callPackage package args;

    packageOverrides = pfinal: pprev: let
      callPyPkg = dir: name: let
        package = import "${builtins.toString dir}/${name}";
        args = builtins.intersectAttrs (builtins.functionArgs package) {
          inherit sources;
          source = getAttr (removeNixSuffix name) sources;
          python3Packages = pfinal;
        };
      in
        pfinal.toPythonModule (final.callPackage package args);
    in
      {
        # httpx = pprev.httpx.overrideAttrs (old: {
        #   inherit (sources.httpx) pname version src;
        # });
        dict2xml = pprev.dict2xml.overrideAttrs (old: {
          inherit (sources.dict2xml) pname version src;
        });
        # nvfetcher-bin neeed packaging
        nvchecker = pprev.nvchecker.overrideAttrs (old: {
          propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [pfinal.packaging];
        });
      }
      // mapPkgs ./python callPyPkg;
  in
    rec
    {
      python3 = prev.python3.override {inherit packageOverrides;};
      python3Packages = python3.pkgs;

      pypy3 = prev.python3.override {inherit packageOverrides;};
      pypy3Packages = pypy3.pkgs;

      python39 = prev.python39.override {inherit packageOverrides;};
      python39Packages = python39.pkgs;

      python310 = prev.python310.override {inherit packageOverrides;};
      python310Packages = python310.pkgs;
    }
    // (mapPkgs ./build-support callPkg)
    // (mapPkgs ./common callPkg)
    // {
      firefox-addons = mapPkgs ./firefox-addons callPkg;
      darwinapps = mapPkgs ./darwin callPkg;
      qbittorrent-enhanced-nox = final.qbittorrent-enhanced.override {guiSupport = false;};
    };

  packages = pkgs: (
    let
      darwinPkgs =
        if pkgs.stdenvNoCC.isDarwin
        then (mapPackages ./darwin (n: pkgs.darwinapps.${removeNixSuffix n}))
        else {};
    in
      (mapPackages ./common (n: pkgs.${removeNixSuffix n}))
      // (mapPackages ./python (n: pkgs.python3.pkgs.${removeNixSuffix n}))
      // (mapPackages ./firefox-addons (n: pkgs.firefox-addons.${removeNixSuffix n}))
      // darwinPkgs
      // {
        qbittorrent-enhanced-nox = pkgs.qbittorrent-enhanced-nox;
      }
  );
}
