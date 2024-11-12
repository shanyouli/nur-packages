{
  stdenv,
  apple-sdk,
  lib,
  source,
  installShellFiles,
}:
stdenv.mkDerivation rec {
  inherit (source) pname src version;
  nativeBuildInputs = [installShellFiles];
  buildInputs = [
    apple-sdk
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
