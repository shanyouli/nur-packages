{
  ebox,
  etaf,
  lib,
  melpaBuild,
  source,
}:
melpaBuild {
  inherit (source) pname version src;
  ename = "etaf-ui";
  files = ''
    (:defaults )
  '';
  # Package-Requires: ((emacs "29.1") (etaf "0.2.2") (ebox "3.0.1"))
  packageRequires = [
    etaf
    ebox
  ];
  meta = {
    homepage = "https://github.com/emacs-taf/etaf-ui";
    description = "Official ETAF component catalog: buttons, forms, panels and window shells";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
