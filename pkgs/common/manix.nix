{
  lib,
  source,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  inherit (source) src pname;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  cargoLock = source.cargoLock."Cargo.lock";

  meta = with lib; {
    description = "A fast CLI documentation searcher for Nix";
    homepage = "https://github.com/kaii-zen/manix/tree/master";
    license = licenses.mpl20;
    mainProgram = "manix";
  };
}
