{
  ebox,
  ecss,
  lib,
  melpaBuild,
  source,
}:
melpaBuild {
  inherit (source) pname version src;
  ename = "etaf";
  files = ''
    (:defaults )
  '';
  # Package-Requires: ((emacs "29.1") (ebox "3.1.0") (ecss "0.1.0"))
  packageRequires = [
    ebox
    ecss
  ];
  meta = {
    homepage = "https://github.com/emacs-taf/etaf";
    description = "Text application framework facade: components, reactive state and hosts";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
