{
  stdenv,
  darwin,
  lib,
  source,
  installShellFiles,
}:
stdenv.mkDerivation rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  nativeBuildInputs = [installShellFiles];
  buildInputs = [
    darwin.apple_sdk.frameworks.CoreVideo
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.SkyLight
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp ./bin/borders $out/bin/
    installManPage ./docs/borders.1
  '';
  meta = with lib; {
    description = "window border system for macOS";
    homepage = "https://github.com/FelixKratz/JankyBorders";
    platforms = platforms.darwin;
    license = licenses.gpl3;
  };
}
