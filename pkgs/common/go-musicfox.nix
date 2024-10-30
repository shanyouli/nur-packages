# https://github.com/go-musicfox/go-musicfox/blob/6d18b6ec232e0f120c6e117ff8a45036dd386909/deploy/nix/default.nix
{
  lib,
  stdenv,
  buildGoModule,
  darwin,
  alsa-lib,
  flac,
  pkg-config,
  source,
}:
buildGoModule rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  vendorHash = null;
  subPackages = ["cmd/musicfox.go"];
  buildInputs =
    lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AudioToolbox
      darwin.apple_sdk.frameworks.AppKit
    ]
    ++ lib.optionals stdenv.isLinux [alsa-lib flac];

  nativeBuildInputs = [pkg-config];
  meta = with lib; {
    description = "go-musicfox是用Go写的又一款网易云音乐命令行客户端";
    homepage = "https://github.com/go-musicfox/go-musicfox";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
