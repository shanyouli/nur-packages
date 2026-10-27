{
  etaf,
  lib,
  melpaBuild,
  source,
}:
melpaBuild {
  inherit (source) pname version src;
  ename = "etaf-db";
  files = ''
    (:defaults )
  '';
  # Package-Requires: ((emacs "29.1") (etaf "0.2.1"))，运行时需要带 SQLite 支持的 Emacs
  packageRequires = [ etaf ];
  meta = {
    homepage = "https://github.com/emacs-taf/etaf-db";
    description = "Database backends for ETAF: SQLite";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
