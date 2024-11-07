{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon
{
  inherit (source) pname version src;
  addonId = "suziwen1@gmail.com";
  meta = with lib; {
    homepage = "https://github.com/zero-peak/ZeroOmega";
    description = " Manage and switch between multiple proxies quickly & easily.";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
