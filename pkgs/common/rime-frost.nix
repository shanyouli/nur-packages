{
  source,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  inherit (source) pname src version;
  # buildPhase = ''
  #   runHook preBuild
  #   mv default.yaml rime_ice_suggestion.yaml
  #   runHook postBuild
  # '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    rm -rf ./others
    rm -rf ./.github
    cp -r ./* $out/share/rime-data/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rime 配置:白霜拼音";
    homepage = "https://github.com/gaboolic/rime-frost";
    license = lib.licenses.gpl3Only;
  };
}
