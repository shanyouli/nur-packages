{
  lib,
  melpaBuild,
  source,
}:
melpaBuild {
  inherit (source) pname version src;
  ename = "elog";
  files = ''
    (:defaults )
  '';
  # Package-Requires: ((emacs "26.1") (cl-lib "0.5"))，cl-lib 已内置
  meta = {
    homepage = "https://github.com/Kinneyzhang/elog";
    description = "A powerful logging system for Emacs Lisp inspired by Log4j, Winston and loguru";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
