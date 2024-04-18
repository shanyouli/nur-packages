{
  lib,
  rustPlatform,
  pkg-config,
  stdenv,
  openssl,
  darwin,
  source,
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  nativeBuildInputs = [pkg-config];
  cargoBuildFlags = ["--package" "seam"];
  cargoTestFlags = ["-p" "seam" "--bin" "seam"];
  doCheck = false;
  cargoLock = source.cargoLock."Cargo.lock";
  buildInputs =
    [openssl]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];
  env = {
    OPENSSL_NO_VENDOR = true;
  };
  passthru.runnable = true;
  meta = with lib; {
    description = "获取多直播平台的直播源";
    homepage = "https://github.com/Borber/seam";
    license = with licenses; [mit unlicense];
    mainProgram = "seam";
  };
}
