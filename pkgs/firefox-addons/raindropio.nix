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
    addonId = "jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack";
    meta = with lib; {
      homepage = "https://app.raindrop.io/";
      description = "All-in-one bookmark manager";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  }
