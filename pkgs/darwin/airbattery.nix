{
  mkDarwinApp,
  source,
  lib,
}:
mkDarwinApp rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  appname = "AirBattery";
  meta = {
    description = "Get the battery level of all your devices on your Mac.";
    homepage = "https://lihaoyun6.github.io/AirBattery/";
  };
}
