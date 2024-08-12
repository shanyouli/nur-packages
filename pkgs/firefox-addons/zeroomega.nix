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
    addonId = "suziwen1@gmail.com";
    meta = with lib; {
      homepage = "https://github.com/zero-peak/ZeroOmega";
      description = " Manage and switch between multiple proxies quickly & easily.";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  }
