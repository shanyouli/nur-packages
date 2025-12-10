{
  lib,
  rustPlatform,
  source,
}:
# {pkgs ? import <nixpkgs> {} }:
# with pkgs;
# with pkgs.lib;
# 不支持 rust1.73
rustPlatform.buildRustPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  cargoLock = source.cargoLock."Cargo.lock";
  # postConfigure = ''
  #   cargo metadata --offline
  # '';
  # preConfigure = ''
  #   cargo update --offline
  # '';
  # cargoBuildFlags = ["--offline"];
  nativeBuildInputs = [ ];

  buildInputs = [ ];
  doCheck = false;
  meta = with lib; {
    description = "Linter for Nu shell scripts that helpfully suggests improvements";
    homepage = "https://github.com/wvhulle/nu-lint";
    license = licenses.mit;
    mainProgram = "nu-lint";
    platforms = platforms.all;
  };
}
