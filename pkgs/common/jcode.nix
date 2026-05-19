{
  rustPlatform,
  source,
  lib,
  pkg-config,
  openssl,
  stdenv,
  apple-sdk,
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;
  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ apple-sdk ];
  cargoLock = source.cargoLock."Cargo.lock";
  meta = with lib; {
    description = "Coding Agent Harness";
    homepage = "https://github.com/1jehuang/jcode";
    license = licenses.mit;
    maintainers = [ ];
  };
}
