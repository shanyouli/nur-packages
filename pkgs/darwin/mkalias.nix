{
  lib,
  rustPlatform,
  apple-sdk,
  source,
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  cargoLock = source.cargoLock."Cargo.lock";
  postConfigure = ''
    cargo metadata --offline
  '';
  buildInputs = [apple-sdk];
  doCheck = false;
  meta = with lib; {
    description = "Simple command-line tool to create Finder aliases";
    homepage = "https://github.com/reckenrode/mkalias";
    license = licenses.gpl3Only;
    mainProgram = "mkalias";
  };
}
