{
  lib,
  python3Packages,
  source,
}:
let
  inherit (python3Packages)
    buildPythonPackage
    click
    json-repair
    prettytable
    pycryptodome
    orjson
    requests
    cryptography
    faster-whisper
    pyfreeproxy
    fake-useragent
    pathvalidate
    rich
    emoji
    bleach
    beautifulsoup4
    aigpy
    av
    tabulate
    mutagen
    ytmusicapi
    ;
in
buildPythonPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  propagatedBuildInputs = [
    click
    json-repair
    prettytable
    pycryptodome
    orjson
    requests
    cryptography
    faster-whisper
    pyfreeproxy
    fake-useragent
    pathvalidate
    rich
    emoji
    bleach
    beautifulsoup4
    aigpy
    av
    tabulate
    mutagen
    ytmusicapi
  ];
  doCheck = false;
  format = "setuptools";
  meta = with lib; {
    description = ''A lightweight music downloader written in pure python.'';
    homepage = "https://github.com/CharlesPikachu/musicdl";
    platforms = platforms.unix;
    maintainers = with maintainers; [ lye ];
    license = licenses.asl20;
  };
}
