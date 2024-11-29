{
  lib,
  stdenvNoCC,
  source,
}:
stdenvNoCC.mkDerivation {
  inherit (source) src pname version;
  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/ttc
    find -name \*.ttc -exec mv {} $out/share/fonts/ttc \;
    runHook postInstall
  '';
  meta = with lib; {
    description = "中英文宽度完美 2:1 字体";
    homepage = "https://github.com/laishulu/Sarasa-Term-SC-Nerd";
    platforms = platforms.all;
  };
}
