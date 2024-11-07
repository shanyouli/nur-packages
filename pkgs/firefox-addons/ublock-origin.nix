{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon
{
  inherit (source) pname version src;
  addonId = "uBlock0@raymondhill.net";
  meta = with lib; {
    homepage = "https://github.com/gorhill/uBlock";
    description = "uBlock Origin - An efficient blocker for Chromium and Firefox. Fast and lean. ";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
