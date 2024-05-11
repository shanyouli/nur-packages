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
  appname = "VimMotion";
  meta = {
    description = "Access macOS UI elements with your fingers stay on keyboard.";
    homepage = "https://github.com/dwarvesf/VimMotionApp";
  };
}
