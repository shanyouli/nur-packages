{
  lib,
  runCommandLocal,
  source,
}:
runCommandLocal "flexfox"
  {
    inherit (source) pname src version;
    meta = with lib; {
      homepage = "https://github.com/yuuqilin/FlexFox";
      description = "Firefox Chrome css";
    };
  }
  ''
    mkdir -p $out
    cp -rv $src/chrome $out/
    cp -rv $src/scripts/user.js $out/
    cp -rv $src/README*.md $out
  ''
