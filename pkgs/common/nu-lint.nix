{
  lib,
  unstable,
  pkg-config,
  libgit2,
  source,
}:
# {pkgs ? import <nixpkgs> {} }:
# with pkgs;
# with pkgs.lib;
# 不支持 rust1.73
# rustc: 用 nixpkgs-unstable 的工具链（rustc≥1.96），满足 nu-lint 新版本的 MSRV。
unstable.rustPlatform.buildRustPackage rec {
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
  # nixpkgs cargoSetupHook 现在强制 LIBGIT2_NO_VENDOR=1（PR #537108），
  # 需要 pkg-config 探测系统 libgit2；libgit2 1.9.7 满足 libgit2-sys 0.18.8 的约束
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 ];
  doCheck = false;
  meta = with lib; {
    description = "Linter for Nu shell scripts that helpfully suggests improvements";
    homepage = "https://github.com/wvhulle/nu-lint";
    license = licenses.mit;
    mainProgram = "nu-lint";
    platforms = platforms.all;
  };
}
