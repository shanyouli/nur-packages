{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon {
  inherit (source) pname version src;
  addonId = "addon@darkreader.org";
  meta = with lib; {
    homepage = "https://darkreader.org/";
    description = "Dark Reader Chrome and Firefox extension";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
