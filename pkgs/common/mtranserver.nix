{
  lib,
  stdenv,
  bun,
  nodejs,
  writableTmpDirAsHomeHook,
  source,
}:

let
  systemInfo =
    {
      aarch64-darwin = {
        bunTarget = "bun-darwin-arm64";
        bunDepsHash = "sha256-nBFuqBMAbJlf18EbEkVjTbIR7Xr2aMXtfPtUtoCbRMk=";
      };
      x86_64-linux = {
        bunTarget = "bun-linux-x64";
        bunDepsHash = "sha256-H+THH3dbtZHYafY8sYcco+abxsMicF2uWcOYBA9MHhU=";
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

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R node_modules $out/node_modules

      runHook postInstall
    '';

    dontFixup = true;
    outputHash = systemInfo.bunDepsHash;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    nodejs
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.bunDeps}/node_modules .
    if [ -d ui ] && [ ! -e ui/node_modules ]; then
      ln -s ../node_modules ui/node_modules
    fi
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    rm -rf dist
    mkdir -p dist

    (cd ui && bun run build)
    bun run scripts/gen-ui-assets.ts
    bun run scripts/gen-swagger-assets.ts
    bun tsoa spec-and-routes
    bun build src/main.ts \
      --compile \
      --target=${systemInfo.bunTarget} \
      --outfile=./dist/mtranserver \
      --minify

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mtranserver_bin="$(
      find . -type f \( -name mtranserver -o -name MTranServer \) -perm -0100 \
        | head -n 1
    )"

    if [ -z "$mtranserver_bin" ]; then
      echo "mtranserver binary was not found; update installPhase after checking build output" >&2
      exit 1
    fi

    install -Dm755 "$mtranserver_bin" "$out/bin/mtranserver"

    runHook postInstall
  '';

  doCheck = false;

  passthru = { inherit (finalAttrs) bunDeps; };

  meta = with lib; {
    description = "Offline translation model server";
    homepage = "https://github.com/xxnuo/MTranServer";
    sourceProvenance = with sourceTypes; [ fromSource ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "mtranserver";
  };
})
