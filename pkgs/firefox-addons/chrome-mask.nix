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
    addonId = "chrome-mask@overengineer.dev";
    meta = with lib; {
      homepage = "https://github.com/denschub/chrome-mask";
      description = "Makes Firefox wear a mask to look like Chrome.";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  }
