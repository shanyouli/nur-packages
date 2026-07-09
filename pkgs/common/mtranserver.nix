{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtranserver";
  version = "4.0.33";

  src = fetchFromGitHub {
    owner = "xxnuo";
    repo = "MTranServer";
    rev = "v${finalAttrs.version}";
    hash = lib.fakeHash;
  };

  bunDeps = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-bun-deps";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R node_modules $out/node_modules

      runHook postInstall
    '';

    dontFixup = true;
    outputHash = lib.fakeHash;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.bunDeps}/node_modules .
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun run build:all

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
      echo "mtranserver binary was not found; update installPhase after checking build:all output" >&2
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
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "mtranserver";
  };
})
