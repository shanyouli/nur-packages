{
  emacs,
  gnumake,
  lib,
  melpaBuild,
  posframe,
  runCommand,
  source,
  stdenv,
}:
let
  packageNames = [
    "ecss"
    "ekp"
    "ebox"
    "etaf"
    "etaf-ui"
    "etaf-gamekit"
    "etaf-posframe"
    "etaf-ext"
    "etaf-db"
    "etaf-install"
    "etaf-hints"
    "etaf-highlight"
    "etaf-translate"
    "etaf-export"
    "etaf-manual"
  ];
  hasPortableNativeBuild = stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin;
  packageDependencies = {
    ecss = [ ];
    ekp = [ ];
    ebox = [ "ecss" ];
    etaf = [
      "ebox"
      "ecss"
    ];
    etaf-ui = [
      "etaf"
      "ebox"
    ];
    etaf-gamekit = [
      "etaf"
      "etaf-ui"
    ];
    etaf-posframe = [
      "etaf"
      "etaf-ui"
    ];
    etaf-ext = [
      "etaf"
      "etaf-ui"
      "etaf-posframe"
    ];
    etaf-db = [ "etaf" ];
    etaf-install = [ ];
    etaf-hints = [
      "etaf-ext"
      "etaf"
      "etaf-ui"
      "ebox"
    ];
    etaf-highlight = [
      "etaf-ext"
      "etaf"
      "etaf-ui"
      "ebox"
    ];
    etaf-translate = [
      "etaf-ext"
      "etaf"
      "etaf-ui"
      "etaf-db"
      "ebox"
    ];
    etaf-export = [
      "etaf-ext"
      "etaf"
      "etaf-ui"
      "ebox"
    ];
    etaf-manual = [
      "etaf"
      "etaf-ui"
    ];
  };
  buildPackage =
    packages: name:
    melpaBuild (
      {
        pname = name;
        ename = name;
        inherit (source) version src;
        packageRequires =
          map (dependency: packages.${dependency}) packageDependencies.${name}
          ++ lib.optional (name == "etaf-posframe") posframe;
        files = ''
          (:defaults
            ("lisp" "lisp/*.el")
            ("dictionaries" "dictionaries/*")
            ("native" "native/*"))
        '';
      }
      // lib.optionalAttrs (name == "ekp" && hasPortableNativeBuild) {
        nativeBuildInputs = [ gnumake ];
        postBuild = ''
          make -C packages/ekp/native PROFILE=portable CC="$CC" EMACS_INCLUDE="${emacs}/include"
        '';
        postInstall = ''
          for pkgdir in $out/share/emacs/site-lisp/elpa/ekp-*/; do
            install -Dm444 packages/ekp/native/ekp${stdenv.hostPlatform.extensions.sharedLibrary} "$pkgdir/native/ekp${stdenv.hostPlatform.extensions.sharedLibrary}"
          done
        '';
      }
    );
  packageBuilds = lib.fix (packages: lib.genAttrs packageNames (buildPackage packages));
  packageOutputPaths = lib.concatStringsSep " " (
    map (name: toString packageBuilds.${name}) packageNames
  );
in
runCommand "etaf-packages-${source.version}"
  {
    meta = {
      homepage = "https://github.com/emacs-taf/etaf";
      description = "ETAF framework and bundled packages";
      license = lib.licenses.gpl3Plus;
      maintainers = [ ];
      pname = "etaf";
      inherit (source) version;
    };
  }
  ''
    mkdir -p "$out/share/emacs/site-lisp"
    for packageOutput in ${packageOutputPaths}; do
      for packageDir in "$packageOutput"/share/emacs/site-lisp/elpa/*; do
        [ -d "$packageDir" ] || continue
        packageName="$(basename "$packageDir")"
        ln -s "$packageDir" "$out/share/emacs/site-lisp/$packageName"
      done
    done
  ''
