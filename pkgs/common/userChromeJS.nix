{
  runCommand,
  lib,
  source,
}:
runCommand "firefox-userchromejs" {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  meta = with lib; {
    homepage = "https://github.com/benzBrake/userChrome.js-Loader";
    description = "Firefox scripts ";
  };
} ''
  mkdir -p $out
  cp -rv $src/profile/chrome/* $out/
''
