{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon
{
  inherit (source) pname version src;
  addonId = "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}";
  meta = with lib; {
    homepage = "https://webextension.org/listing/tab-discard.html";
    description = "Dark Reader Chrome and Firefox extension";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
