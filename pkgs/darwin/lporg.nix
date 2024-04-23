{
  lib,
  buildGoModule,
  source,
}:
buildGoModule rec {
  inherit (source) pname src;
  vendorHash = "sha256-GQaIfUtM3iDQ9jmrSMqYvcPysigdu7w10xGDIYv4OY8=";
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
  meta = with lib; {
    description = "Organize Your macOS Launchpad Apps";
    homepage = "https://github.com/blacktop/lporg";
    license = licenses.mit;
    mainProgram = "lporg";
  };
}
