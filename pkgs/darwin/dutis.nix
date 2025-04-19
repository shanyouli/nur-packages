{
  lib,
  rustPlatform,
  source,
  apple-sdk_13,
  ...
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname src version;
  cargoLock = source.cargoLock."Cargo.lock";
  doCheck = false;
  buildInputs = [ apple-sdk_13 ];
  meta = with lib; {
    description = "A command-line tool to select default applications, based on duti";
    homepage = "https://github.com/tsonglew/dutis";
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "dutis";
  };
}
