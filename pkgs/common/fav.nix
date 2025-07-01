{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
  stdenv,
  apple-sdk_13,
  source,
  ffmpeg,
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
  postConfigure = ''
    cargo metadata --offline
  '';
  # preConfigure = ''
  #   cargo update --offline
  # '';
  # cargoBuildFlags = ["--offline"];
  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    ffmpeg
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_13 ];
  doCheck = false;
  env = {
    OPENSSL_NO_VENDOR = true;
  };
  meta = with lib; {
    description = "Back up your favorite bilibili resources with CLI";
    homepage = "https://github.com/kingwingfly/fav";
    changelog = "https://github.com/kingwingfly/fav/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "fav";
  };
}
