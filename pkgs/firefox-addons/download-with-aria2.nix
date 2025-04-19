{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon {
  inherit (source) pname version src;
  addonId = "firefox@downloadWithAria2";
  meta = with lib; {
    homepage = "https://github.com/jc3213/download_with_aria2";
    description = "Browser extension for aria2c json-rpc ";
    license = licenses.lgpl2;
    platforms = platforms.all;
  };
}
