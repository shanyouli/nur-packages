{
  lib,
  ecss,
  melpaBuild,
  source,
}:
melpaBuild {
  inherit (source) pname version src;
  ename = "ebox";
  files = ''
    (:defaults )
  '';
  # Package-Requires: ((emacs "29.1") (ecss "0.1.0"))
  packageRequires = [ ecss ];
  meta = {
    homepage = "https://github.com/emacs-taf/ebox";
    description = "Pixel-perfect box model renderer: box/flex/grid layout and incremental buffer publication";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
