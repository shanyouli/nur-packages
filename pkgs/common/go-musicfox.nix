# https://github.com/go-musicfox/go-musicfox/blob/6d18b6ec232e0f120c6e117ff8a45036dd386909/deploy/nix/default.nix
{
  lib,
  stdenv,
  buildGoModule,
  apple-sdk_13,
  alsa-lib,
  flac,
  pkg-config,
  source,
}:
buildGoModule rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  vendorHash = null;
  subPackages = [ "cmd/musicfox.go" ];
  buildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_13 ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      flac
    ];

  nativeBuildInputs = [ pkg-config ];
  meta = with lib; {
    description = "go-musicfox是用Go写的又一款网易云音乐命令行客户端";
    homepage = "https://github.com/go-musicfox/go-musicfox";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
