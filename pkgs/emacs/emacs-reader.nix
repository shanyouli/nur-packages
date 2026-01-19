{
  lib,
  stdenv,
  melpaBuild,
  mupdf-headless,
  pkg-config,
  source,
}:

let
  render-core = stdenv.mkDerivation {
    inherit (source) version scr;
    pname = "render-core";

    strictDeps = true;

    buildFlags = [
      "CC=cc"
      "USE_PKGCONFIG=yes"
    ];

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [ mupdf-headless ];

    installPhase = ''
      runHook preInstall

      install -Dm444 -t $out/lib/ render-core${stdenv.targetPlatform.extensions.sharedLibrary}
      runHook postInstall
    '';
  };

in
melpaBuild {
  pname = "reader";

  inherit src version;

  files = ''
    (:defaults "${lib.getLib render-core}/lib/render-core.*"))
  '';

  meta = {
    homepage = "https://codeberg.org/divyaranjan/emacs-reader";
    description = "An all-in-one document reader for all formats in Emacs, backed by MuPDF";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
