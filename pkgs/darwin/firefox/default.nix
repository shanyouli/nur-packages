{
  mkDarwinApp,
  sources,
  withEsr ? true,
  withFx ? true,
  lib,
  fetchurl,
  ...
}: let
  fxSrc = sources.userChromeJS.src;
  pname =
    if withEsr
    then "firefox-esr"
    else "firefox";
  source = builtins.fromJSON (builtins.readFile ./sources.json);
  version = source."${pname}".version;
  src = fetchurl {
    inherit (source."${pname}") url sha256;
  };
in
  mkDarwinApp rec {
    inherit pname version src;
    appname = "Firefox";
    postInstall = lib.optionalString withFx ''
      cp -ar ${fxSrc}/program/config.js $out/Applications/Firefox.app/Contents/Resources/config.js
      mkdir -p $out/Applications/Firefox.app/Contents/Resources/defaults/pref
      cp -ar ${fxSrc}/program/defaults/pref/config-prefs.js $out/Applications/Firefox.app/Contents/Resources/defaults/pref
    '';
    meta = {
      description = "Mozilla Firefox, free web browser (binary package)";
      homepage = "http://www.mozilla.com/en-US/firefox/";
    };
  }
