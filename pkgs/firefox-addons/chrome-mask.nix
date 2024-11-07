{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon
{
  inherit (source) pname version src;
  addonId = "chrome-mask@overengineer.dev";
  meta = with lib; {
    homepage = "https://github.com/denschub/chrome-mask";
    description = "Makes Firefox wear a mask to look like Chrome.";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
