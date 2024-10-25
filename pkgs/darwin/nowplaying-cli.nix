{
  stdenv,
  darwin,
  lib,
  source,
}:
stdenv.mkDerivation rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  buildInputs = [darwin.apple_sdk.frameworks.Cocoa];
  installPhase = ''
    mkdir -p $out/bin
    cp nowplaying-cli $out/bin/
  '';
  meta = with lib; {
    description = "macOS command-line utility for retrieving currently playing media";
    homepage = "https://github.com/kirtan-shah/nowplaying-cli";
    platforms = platforms.darwin;
    license = licenses.gpl3;
  };
}
