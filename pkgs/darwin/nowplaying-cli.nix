{
  stdenv,
  lib,
  apple-sdk_13,
  source,
}:
stdenv.mkDerivation rec {
  inherit (source) pname src version;
  buildInputs = [ apple-sdk_13 ];
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
