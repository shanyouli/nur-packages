{
  source,
  melpaBuild,
  lib,
}:
melpaBuild {
  inherit (source) pname version src;
  ename = "emt";
  files = ''
    (:defaults )
  '';
  meta = {
    homepage = "https://github.com/roife/emt";
    description = "Emacs macOS Tokenizer, tokenizing CJK words with macOS's built-in NLP tokenizer. ";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
