{
  lib,
  buildGoModule,
  source,
}:
buildGoModule rec {
  inherit (source) pname src;
  vendorHash = "sha256-+trt7BLgy1d1ENrqf/J0mf8ECnKfYl3P/KibQQxNRN4=";
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "将 clash.meta 格式的配置文件或链接转换为 sing-box 格式";
    homepage = "https://github.com/xmdhs/clash2singbox";
    license = licenses.mit;
    mainProgram = "clash2singbox";
  };
}
