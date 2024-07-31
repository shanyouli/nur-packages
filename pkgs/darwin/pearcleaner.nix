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
  appname = "Pearcleaner";
  meta = {
    description = "appclear ";
    homepage = "https://github.com/alienator88/Pearcleaner";
  };
}
