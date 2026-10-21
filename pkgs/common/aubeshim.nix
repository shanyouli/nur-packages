{
  lib,
  rustPlatform,
  source,
}:
# 纯 Rust 依赖（anyhow/clap/glob/serde/toml），无系统库需要；
# MSRV 1.75，stable 工具链即可，无需 unstable。
rustPlatform.buildRustPackage rec {
  inherit (source) pname src;
  version = lib.removePrefix "v" source.version;
  cargoLock = source.cargoLock."Cargo.lock";
  doCheck = false;
  meta = with lib; {
    description = "Replace all {bun, npm, pnpm, yarn} with aube";
    homepage = "https://github.com/mwolson/aubeshim";
    license = licenses.mit;
    mainProgram = "aubeshim";
  };
}
