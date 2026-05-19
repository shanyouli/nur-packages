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
    description = "Coding Agent Harness";
    homepage = "https://github.com/1jehuang/jcode";
    license = licenses.mit;
    maintainers = [ ];
  };
}
