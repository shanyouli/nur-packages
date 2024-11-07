{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon
{
  inherit (source) pname version src;
  addonId = "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}";
  meta = with lib; {
    homepage = "https://violentmonkey.github.io";
    description = "An open source userscript manager.";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
