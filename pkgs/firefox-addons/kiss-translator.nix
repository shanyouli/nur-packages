{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon {
  inherit (source) pname version src;
  addonId = "{fb25c100-22ce-4d5a-be7e-75f3d6f0fc13}";
  meta = with lib; {
    homepage = "https://github.com/fishjar/kiss-translator";
    description = "Simple, open source bilingual translation extension & Greasemonkey script";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
