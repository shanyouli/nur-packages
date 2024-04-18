{
  runCommand,
  p7zip,
  lib,
  source,
}:
runCommand "firefox-utils" {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  nativeBuildInputs = [p7zip];
  meta = with lib; {
    homepage = "https://github.com/xiaoxiaoflood/firefox-scripts";
    description = "Firefox scripts ";
  };
} ''
  mkdir -p $out/share
  7z x -y $src -o$out/share
''
