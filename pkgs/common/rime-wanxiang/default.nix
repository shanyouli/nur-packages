{
  stdenvNoCC,
  lib,
  sources,
  p7zip,
  fetchurl,
  fuzu ? "moqi",
  ...
}:
let
  source =
    let
      sourceJson = builtins.fromJSON (builtins.readFile ./sources.json);
    in
    if (builtins.hasAttr fuzu sourceJson) then sourceJson."${fuzu}" else sourceJson.base;
in
stdenvNoCC.mkDerivation rec {
  inherit (source) pname version;
  src = fetchurl { inherit (source) url sha256; };
  phases = [
    # "unpackPhase"
    "installPhase"
  ];
  nativeBuildInputs = [ p7zip ];
  # unpackCmd = ''
  #   7z x -y $src
  # '';
  # buildPhase = ''
  #   runHook preBuild
  #   mv default.yaml rime_ice_suggestion.yaml
  #   runHook postBuild
  # '';
  installPhase = ''
    7z x -y $src
    runHook preInstall
    mkdir -p $out/share/rime-data
    rm -rf ./.github
    cp -r ./* $out/share/rime-data/
    cp -r ${sources.wanxiang-lts-zh-hans.src} $out/share/rime-data/${lib.getName sources.wanxiang-lts-zh-hans.src}
    [[ -f $out/share/rime-data/env-vars ]] && rm -rf $out/share/rime-data/env-vars
    runHook postInstall
  '';

  meta = with lib; {
    description = "Rime 配置:万象输入法";
    homepage = "https://github.com/amzxyz/rime_wanxiang_pro";
    license = lib.licenses.gpl3Only;
  };
}
