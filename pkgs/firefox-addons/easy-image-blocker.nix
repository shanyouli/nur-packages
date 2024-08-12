{
  mkFirefoxAddon,
  lib,
  source,
  fetchurl,
}: let
  src =
    if (builtins.hasAttr "src" source)
    then source.src
    else fetchurl {inherit (source) url sha256;};
in
  mkFirefoxAddon
  {
    inherit (source) pname version;
    inherit src;
    addonId = "@easyimageblocker";
    meta = with lib; {
      homepage = "https://addons.mozilla.org/en-US/firefox/addon/easy-image-blocker/";
      description = "Easy Image Blocker is the Add-on to control the loading of the image.";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
