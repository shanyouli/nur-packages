{
  rustPlatform,
  source,
  lib,
}:

rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;
  nativeBuildInputs = [ rustPlatform.bindgenHook ];
  cargoLock = source.cargoLock."Cargo.lock";
  meta = with lib; {
    description = "A Rust implementation of Easy Web Token";
    homepage = "https://github.com/Master-Hash/ewt-rs";
    license = licenses.mit;
    maintainers = [ ];
  };
}
