{
  lib,
  stdenv,
  source,
  pnpm,
  nodejs,
  makeWrapper,
  jq,
  patchelf,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-/cxuMTcMKU1jwkvQhPI/+Em1sadBDEJraR54rBw/7wk=";
  };
  nativeBuildInputs = [
    makeWrapper
    pnpm.configHook
    nodejs
    jq
    patchelf
  ];
  buildPhase = ''
    runHook preBuild
    pnpm build
    pnpm rebuild
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    packageOutDir="$out/lib/node_modules/$(jq --raw-output '.name' package.json)"
    mkdir -p "$packageOutDir"
    cp -r node_modules "$packageOutDir/node_modules"
    while IFS=" " read -ra f; do
      cp -rv "$f" "$packageOutDir"
    done < <(jq --raw-output '.files.[]' ./package.json)
    while IFS=" " read -ra bin; do
      mkdir -p "$out/bin"
      makeWrapper ${lib.getExe nodejs}  "$out/bin/''${bin[0]}" --add-flags "$packageOutDir/''${bin[1]}"
    done < <(jq --raw-output '(.bin | type) as $typ | if $typ == "string" then
        .name + " " + .bin
        elif $typ == "object" then .bin | to_entries | map(.key + " " + .value) | join("\n")
        elif $typ == "null" then empty
        else "invalid type " + $typ | halt_error end' ./package.json)
    [ -f ./package.json ] && cp -rv ./package.json "$packageOutDir"
    [ -f ./LICENSE ] && cp -rv ./LICENSE "$packageOutDir"
    runHook postInstall
  '';
  passthru = { inherit (finalAttrs) pnpmDeps; };
  meta = with lib; {
    description = "🎵 一个可播放及下载音乐的 Node.js 命令行工具 ";
    homepage = "https://github.com/zonemeen/musicn";
    license = licenses.mit;
  };
})
