{
  lib,
  melpaBuild,
  source,
}:
melpaBuild {
  inherit (source) pname version src;
  ename = "ecss";
  files = ''
    (:defaults )
  '';
  # Package-Requires: ((emacs "28.1"))，无外部 emacs 包依赖
  meta = {
    homepage = "https://github.com/emacs-taf/ecss";
    description = "Pure extensible CSS cascade engine: selectors, specificity, cascade and computed styles";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
