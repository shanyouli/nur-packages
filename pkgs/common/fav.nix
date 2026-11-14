{
  lib,
  stdenv,
  unstable,
  pkg-config,
  openssl,
  ffmpeg,
  apple-sdk,
  source,
}:
# {pkgs ? import <nixpkgs> {} }:
# with pkgs;
# with pkgs.lib;
# 不支持 rust1.73
# rustc: 用 nixpkgs-unstable 的工具链（rustc≥1.96），满足 vergen 10.x 的 MSRV；
# openssl/ffmpeg/apple-sdk 等系统库仍用默认（stable）。
unstable.rustPlatform.buildRustPackage rec {
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
    unstable.rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    ffmpeg
    # nixpkgs cargoSetupHook 现在强制 AWS_LC_SYS_USE_SYSTEM=1（PR #537108），
    # 需要系统 aws-lc（需 nixpkgs 5.x 版本打包，含 rust bindings 与 pkg-config 模块）
    unstable.aws-lc
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk ];
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
