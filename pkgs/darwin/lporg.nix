{
  lib,
  buildGoModule,
  source,
}:
buildGoModule rec {
  inherit (source) pname src;
  vendorHash = "sha256-a3bmTZKMcPvDEDp1RZ9iGEfPuJNXJN0s6NLVVDCPrFo=";
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/blacktop/lporg/cmd.AppVersion=${version}"
    "-X=github.com/blacktop/lporg/cmd.AppBuildTime=1970-01-01T00:00:00Z"
  ];
  doCheck = false;
  subPackages = ["."];
  meta = with lib; {
    description = "Organize Your macOS Launchpad Apps";
    homepage = "https://github.com/blacktop/lporg";
    license = licenses.mit;
    mainProgram = "lporg";
  };
}
