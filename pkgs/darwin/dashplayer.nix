{
  mkDarwinApp,
  makeWrapper,
  source,
  lib,
  stdenv,
  ...
}:
mkDarwinApp rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  appname = "Dash Player";
  meta = {
    description = "video player";
    homepage = "https://solidspoon.xyz/DashPlayer/home.html";
    broken = ! stdenv.isAarch64;
  };
  nativeBuildInputs = [makeWrapper];
  # postInstall = ''
  #   mkdir -p $out/bin
  #   makeWrapper $out/Applications/IINA.app/Contents/MacOS/iina-cli $out/bin/iina
  # '';
}
