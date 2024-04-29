{
  lib,
  buildGoModule,
  source,
}:
buildGoModule rec {
  inherit (source) pname src;
  vendorHash = "sha256-9Ey4roUm/Y6GfFmLD6ij/A+YIgetStawWmhD+Iq3qc8=";
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;

  excludedPackages = ["./test"];
  ldflags = ["-s" "-w"];
  tags = ["with_gvisor"];
  doCheck = false;
  meta = with lib; {
    description = "A simple Python Pydantic model for Honkai: Star Rail parsed data from the Mihomo API";
    homepage = "https://github.com/MetaCubeX/mihomo";
    license = licenses.gpl3Only;
    mainProgram = "mihomo";
  };
}
