{
  lib,
  stdenv,
  installShellFiles,
  source,
  p7zip,
}:
stdenv.mkDerivation rec {
  inherit (source) pname version src;
  phases = ["unpackPhase" "installPhase"];
  nativeBuildInputs = [p7zip installShellFiles];
  unpackCmd = ''
    7z x -y $src
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    mkdir -p "$out/Applications/AeroSpace.app"
    cp -a AeroSpace.app/. $out/Applications/AeroSpace.app
    install -D -m755 ./bin/aerospace $out/bin/aerospace
    for i in manpage/* ; do
      echo $i
      installManPage $i
    done
    runHook postInstall
  '';

  meta = {
    description = "AeroSpace is an i3-like tiling window manager for macOS";
    homepage = "https://github.com/nikitabobko/AeroSpace";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "aerospace";
  };
}
