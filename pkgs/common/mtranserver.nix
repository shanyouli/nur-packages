{
  lib,
  stdenv,
  bun,
  jq,
  nodejs,
  makeWrapper,
  writableTmpDirAsHomeHook,
  source,
}:

let
  # 上游明确不支持把 ONNX 运行期打包进单文件可执行（scripts/build.ts 里 --single 直接抛错），
  # 因此这里按上游 Dockerfile 的方式打包：bun build --node 产出 dist/*.js，运行时用 node 执行，
  # onnxruntime-node 作为 external 依赖从 node_modules 解析，原生库随包携带。
  platformInfo =
    {
      aarch64-darwin = {
        bunDepsHash = "sha256-GFN8enB5B2N4PW/CPQPuwSume0mEFBe3B8vQrZvt2uo=";
        onnxRuntimePlatform = "darwin";
        onnxRuntimeArch = "arm64";
      };
      x86_64-linux = {
        bunDepsHash = "sha256-GFN8enB5B2N4PW/CPQPuwSume0mEFBe3B8vQrZvt2uo=";
        onnxRuntimePlatform = "linux";
        onnxRuntimeArch = "x64";
      };
    }
    .${stdenv.hostPlatform.system}
      or (throw "${source.pname}: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  inherit (source) pname src version;
  bunDeps = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-bun-deps";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      bun
      nodejs
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="*" \
        --force \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"
      (cd ui && bun install \
        --cpu="*" \
        --force \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*")

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R node_modules $out/node_modules
      mkdir -p $out/ui
      cp -R ui/node_modules $out/ui/node_modules

      runHook postInstall
    '';

    dontFixup = true;
    outputHash = platformInfo.bunDepsHash;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    jq
    nodejs
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.bunDeps}/node_modules .
    mkdir -p ui
    cp -R ${finalAttrs.bunDeps}/ui/node_modules ui/node_modules
    chmod -R u+w node_modules ui/node_modules
    patchShebangs node_modules
    patchShebangs ui/node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # 上游脚本：构建 UI、生成 assets 映射、tsoa 生成路由与 spec，
    # 再产出 dist/converter-worker.js 与 dist/main.js（onnxruntime-node 保持 external）。
    bun run build:node

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    runtimeDir=$out/lib/mtranserver
    mkdir -p "$runtimeDir"
    cp -R dist "$runtimeDir/dist"

    # 运行期只需要 external 的依赖（onnxruntime-node、@sctg/sentencepiece-js），
    # 其余依赖已被 bun build 打进 dist/main.js 与 dist/converter-worker.js。
    # 这里按 package.json 的 dependencies 递归收集闭包，避免把 electron、
    # onnxruntime-web 等 devDependencies 拖进运行期闭包。
    runtimeVisited=""
    copy_runtime_deps() {
      for dep in "$@"; do
        case " $runtimeVisited " in
          *" $dep "*) continue ;;
        esac
        runtimeVisited="$runtimeVisited $dep"
        if [ ! -d "node_modules/$dep" ]; then
          echo "missing runtime dependency: $dep" >&2
          exit 1
        fi
        mkdir -p "$(dirname "$runtimeDir/node_modules/$dep")"
        cp -R "node_modules/$dep" "$runtimeDir/node_modules/$dep"
        copy_runtime_deps $(jq -r '(.dependencies // {}) | keys[]' "node_modules/$dep/package.json")
      done
    }
    copy_runtime_deps onnxruntime-node @sctg/sentencepiece-js
    echo "runtime dependencies:$runtimeVisited"

    # onnxruntime-node 的 bin/ 目录里带了所有平台的原生库，只保留当前平台
    # （core/backend.ts 用 bin/napi-v6/<platform>/<arch> 定位原生库）。
    onnxBin="$runtimeDir/node_modules/onnxruntime-node/bin"
    onnxNative="$onnxBin/napi-v6/${platformInfo.onnxRuntimePlatform}/${platformInfo.onnxRuntimeArch}"
    if [ -d "$onnxNative" ]; then
      preserved=$(mktemp -d)
      mv "$onnxNative" "$preserved/native"
      rm -rf "$onnxBin"
      mkdir -p "$(dirname "$onnxNative")"
      mv "$preserved/native" "$onnxNative"
      rm -rf "$preserved"
    fi

    # dist/ 下是 ESM 产物，需要 package.json 的 type 标记才能被 node 按 module 解析。
    echo '{ "name": "mtranserver", "version": "'${finalAttrs.version}'", "private": true, "type": "module" }' \
      > "$runtimeDir/package.json"

    # 冒烟检查：外部依赖必须能从运行期目录解析，且 onnxruntime 原生库能加载。
    (cd "$runtimeDir" && node --input-type=module -e "
      const ort = await import('onnxruntime-node');
      if (typeof ort.InferenceSession?.create !== 'function') throw new Error('onnxruntime-node loaded without InferenceSession');
      await import('@sctg/sentencepiece-js');
    ")
    # 入口的静态 import 会加载 onnxruntime，--help 能跑通说明原生依赖真的可用。
    (cd "$runtimeDir" && node dist/main.js --help > /dev/null)

    mkdir -p $out/bin
    makeWrapper ${lib.getExe nodejs} $out/bin/mtranserver \
      --add-flags "$runtimeDir/dist/main.js"

    runHook postInstall
  '';

  doCheck = false;
  # 预编译的 .node / .dylib 不要动：strip 会破坏 macOS arm64 的代码签名
  dontStrip = true;

  passthru = { inherit (finalAttrs) bunDeps; };

  meta = with lib; {
    description = "Offline translation model server";
    homepage = "https://github.com/xxnuo/MTranServer";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "mtranserver";
  };
})
