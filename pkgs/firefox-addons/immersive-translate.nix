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
    addonId = "{5efceaa7-f3a2-4e59-a54b-85319448e305}";
    meta = with lib; {
      homepage = "https://immersivetranslate.com/";
      description = "Immersive Dual Web Page Translation Extension ";
      # license = licenses.gpl3;
      platforms = platforms.all;
    };
  }
