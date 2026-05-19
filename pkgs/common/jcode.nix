{
  rustPlatform,
  source,
  lib,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;
  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];
  cargoLock = source.cargoLock."Cargo.lock";
  meta = with lib; {
    description = "Coding Agent Harness";
    homepage = "https://github.com/1jehuang/jcode";
    license = licenses.mit;
    maintainers = [ ];
  };
}
