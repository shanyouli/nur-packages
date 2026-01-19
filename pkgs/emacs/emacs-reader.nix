{
  lib,
  stdenv,
  melpaBuild,
  mupdf-headless,
  pkg-config,
  source,
}:

melpaBuild {
  pname = "reader";
  inherit (source) src version;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ mupdf-headless ];
  files = ''
    (:defaults "render-core.*"))
  '';
  preBuild = "make clean all CC=$CC USE_PKGCONFIG=yes";
  runInstall = ''
    install -Dm444 -t $out/lib/ render-core${stdenv.targetPlatform.extensions.sharedLibrary}
  '';
  meta = {
    homepage = "https://codeberg.org/divyaranjan/emacs-reader";
    description = "An all-in-one document reader for all formats in Emacs, backed by MuPDF";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
