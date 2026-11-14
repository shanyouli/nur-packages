{
  lib,
  stdenv,
  melpaBuild,
  mupdf-headless,
  pkg-config,
  source,
}:

melpaBuild rec {
  ename = "emureader";
  pname = "emureader";
  inherit (source) src version;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ mupdf-headless ];
  files = ''
    (:defaults "emureader-dyn${stdenv.targetPlatform.extensions.sharedLibrary}")
  '';
  preBuild = ''
    export EMACSLOADPATH=".:$EMACSLOADPATH"
    make clean all CC=$CC USE_PKGCONFIG=yes
  '';
  postInstall = ''
    dir=$out/share/emacs/site-lisp/elpa/emureader-${version}
    install -Dm444 emureader-dyn${stdenv.targetPlatform.extensions.sharedLibrary} $dir/
  '';
  meta = {
    homepage = "https://codeberg.org/MonadicSheep/emureader";
    description = "An all-in-one document reader for all formats in Emacs, backed by MuPDF";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
