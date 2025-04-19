{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon {
  inherit (source) pname version src;
  addonId = "@easyimageblocker";
  meta = with lib; {
    homepage = "https://addons.mozilla.org/en-US/firefox/addon/easy-image-blocker/";
    description = "Easy Image Blocker is the Add-on to control the loading of the image.";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
