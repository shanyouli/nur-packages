{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon {
  inherit (source) pname version src;
  addonId = "{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}";
  meta = with lib; {
    homepage = "https://github.com/brookhong/Surfingkeys";
    description = "Map your keys for web surfing, expand your browser with javascript and keyboard. ";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
