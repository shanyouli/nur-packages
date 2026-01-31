{
  rustPlatform,
  source,
  lib,
  clang,
}:

rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;
  nativeBuildInputs = [ rustPlatform.bindgenHook clang ];
  cargoLock = source.cargoLock."Cargo.lock";
  env = {
    LIBCLANG_PATH = "${clang}/lib";
  };
  meta = with lib; {
    description = "A Rust implementation of Easy Web Token";
    homepage = "https://github.com/Master-Hash/ewt-rs";
    license = licenses.mit;
    maintainers = [ ];
  };
}