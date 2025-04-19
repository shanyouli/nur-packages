{
  lib,
  stdenvNoCC,
  source,
  p7zip,
}:
stdenvNoCC.mkDerivation {
  inherit (source) src pname version;
  sourceRoot = ".";
  nativeBuildInputs = [ p7zip ];
  unpackPhase = ''
    mkdir -p $out/tmp
    7z x -y $src -o$out/tmp
    pushd $out/tmp
    find -name \*.ttf -exec mkdir -p $out/share/fonts/truetype \; -exec mv {} $out/share/fonts/truetype \;
    popd
    rm -rf $out/tmp
  '';
  dontInstall = true;
  meta = with lib; {
    description = "我的自定义 iosvake";
    homepage = "https://github.com/shanyouli/iosevka";
    platforms = platforms.all;
  };
}
