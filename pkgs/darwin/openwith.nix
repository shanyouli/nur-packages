{
  lib,
  rustPlatform,
  source,
  apple-sdk,
  ...
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname src version;
  cargoLock = source.cargoLock."Cargo.lock";
  doCheck = false;
  buildInputs = [ apple-sdk ];
  meta = with lib; {
    description = "Manage macOS file extension associations from the terminal ";
    homepage = "https://github.com/ColeMei/openwith";
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "openwith";
  };
}
