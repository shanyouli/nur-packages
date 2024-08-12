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
    addonId = "{fb25c100-22ce-4d5a-be7e-75f3d6f0fc13}";
    meta = with lib; {
      homepage = "https://github.com/fishjar/kiss-translator";
      description = "Simple, open source bilingual translation extension & Greasemonkey script";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  }
