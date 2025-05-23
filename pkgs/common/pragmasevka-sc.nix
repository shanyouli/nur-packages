{
  lib,
  stdenvNoCC,
  source,
}:
stdenvNoCC.mkDerivation {
  inherit (source) src pname version;
  buildCommand = ''
    dst=$out/share/fonts/truetype
    mkdir -p "$dst"
    install -v -m444 "$src" "$dst/${lib.getName source.src}"
  '';
  meta = with lib; {
    description = "我的自定义 iosvake, 使用 LXGW-wenKai 作为中文字体";
    homepage = "https://github.com/shanyouli/iosevka";
    platforms = platforms.all;
  };
}
