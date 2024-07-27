{
  mkDarwinApp,
  fetchurl,
}: let
  pname = "lyricsx";
  source = builtins.fromJSON (builtins.readFile ./source.json);
  version = source."${pname}".version;
  src = fetchurl {
    inherit (source."${pname}") url sha256;
  };
in
  mkDarwinApp rec {
    inherit pname src version;
    appname = "LyricsX";
    meta = {
      description = "🎶 Ultimate lyrics app for macOS. ";
      homepage = "https://github.com/ddddxxx/LyricsX";
    };
  }
