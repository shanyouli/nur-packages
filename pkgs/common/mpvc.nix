{
  lib,
  stdenv,
  socat,
  makeWrapper,
  source,
}:
stdenv.mkDerivation rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  makeFlags = ["PREFIX=$(out)"];
  installFlags = ["PREFIX=$(out)"];

  postInstall = ''
    wrapProgram $out/bin/mpvc --prefix PATH : "${socat}/bin/"
  '';

  nativeBuildInputs = [makeWrapper];
  buildInputs = [socat];

  meta = with lib; {
    description = "A mpc-like control interface for mpv";
    mainProgram = "mpvc";
    homepage = "https://gmt4.github.io/mpvc/";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
