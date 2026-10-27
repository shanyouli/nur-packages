{
  etaf,
  etaf-ui,
  lib,
  melpaBuild,
  posframe,
  source,
}:
melpaBuild {
  inherit (source) pname version src;
  ename = "etaf-posframe";
  files = ''
    (:defaults )
  '';
  # Package-Requires: ((emacs "29.1") (etaf "0.3.0") (etaf-ui "0.3.0") (posframe "0.9.0"))
  # posframe 来自 nixpkgs emacsPackages
  packageRequires = [
    etaf
    etaf-ui
    posframe
  ];
  meta = {
    homepage = "https://github.com/emacs-taf/etaf-posframe";
    description = "Floating ETAF panels in child frames";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
