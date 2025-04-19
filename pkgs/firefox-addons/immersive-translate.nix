{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon {
  inherit (source) pname version src;
  addonId = "{5efceaa7-f3a2-4e59-a54b-85319448e305}";
  meta = with lib; {
    homepage = "https://immersivetranslate.com/";
    description = "Immersive Dual Web Page Translation Extension ";
    # license = licenses.gpl3;
    platforms = platforms.all;
  };
}
