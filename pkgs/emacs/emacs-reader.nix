{
  lib,
  stdenv,
  melpaBuild,
  mupdf-headless,
  pkg-config,
  source,
}:

melpaBuild rec {
  ename = "reader";
  pname = "emacs-reader";
  inherit (source) src version;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ mupdf-headless ];
  files = ''
    (:defaults "render-core${stdenv.targetPlatform.extensions.sharedLibrary}")
  '';
  preBuild = ''
    export EMACSLOADPATH=".:$EMACSLOADPATH"
    make clean all CC=$CC USE_PKGCONFIG=yes
  '';
  postInstall = ''
    dir=$out/share/emacs/site-lisp/elpa/reader-${version}
    install -Dm444 render-core${stdenv.targetPlatform.extensions.sharedLibrary} $dir/
  '';
  meta = {
    homepage = "https://codeberg.org/divyaranjan/emacs-reader";
    description = "An all-in-one document reader for all formats in Emacs, backed by MuPDF";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
