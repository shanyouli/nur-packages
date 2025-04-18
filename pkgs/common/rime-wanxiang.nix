{
  source,
  stdenvNoCC,
  lib,
  sources,
  p7zip,
}:
stdenvNoCC.mkDerivation rec {
  inherit (source) pname src version;
  phases = [
    "unpackPhase"
    "installPhase"
  ];
  nativeBuildInputs = [ p7zip ];
  unpackCmd = ''
    7z x -y $src
  '';
  # buildPhase = ''
  #   runHook preBuild
  #   mv default.yaml rime_ice_suggestion.yaml
  #   runHook postBuild
  # '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    rm -rf ./.github
    cp -r ./* $out/share/rime-data/
    cp -r ${sources.wanxiang-lts-zh-hans.src} $out/share/rime-data/${lib.getName sources.wanxiang-lts-zh-hans.src}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rime 配置:万象输入法";
    homepage = "https://github.com/amzxyz/rime_wanxiang_pro";
    license = lib.licenses.gpl3Only;
  };
}
