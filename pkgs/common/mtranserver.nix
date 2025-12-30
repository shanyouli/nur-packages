# 编译太复杂，直接使用 预编译
{
  lib,
  stdenvNoCC,
  sources,
}:
let
  source =
    if stdenvNoCC.isLinux then
      if stdenvNoCC.isAarch64 then
        sources."mtranserver.linux.arm64"
      else
        sources."mtranserver.linux.amd64"
    else if stdenvNoCC.isAarch64 then
      sources."mtranserver.mac.arm64"
    else
      sources."mtranserver.mac.amd64";
  pname = "mtranserver";
in
stdenvNoCC.mkDerivation {
  inherit (source) src version;
  inherit pname;
  phases = [ "installPhase" ];
  installPhase = ''
    runHook preInstall
    install -D -m755  $out/bin/mtranserver $src
    runHook postInstall
  '';

  meta = with lib; {
    description = "Offline translation model server";
    homepage = "https://github.com/xxnuo/MTranServer";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64=darwin"
    ];
    mainProgram = "mtranserver";
  };
}
