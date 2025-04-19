{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon {
  inherit (source) pname version src;
  addonId = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
  meta = with lib; {
    homepage = "https://add0n.com/stylus.html";
    description = "Stylus - Userstyles Manager";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
