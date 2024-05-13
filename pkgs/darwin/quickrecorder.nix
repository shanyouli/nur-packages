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
  appname = "QuickRecorder";
  meta = {
    description = "A lightweight screen recorder based on ScreenCapture Kit for macOS";
    homepage = "https://lihaoyun6.github.io/quickrecorder/";
  };
}
