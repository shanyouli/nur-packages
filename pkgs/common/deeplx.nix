{
  lib,
  buildGoModule,
  source,
}:
buildGoModule rec {
  inherit (source) pname src;
  vendorHash = "sha256-kTSMY4K07hpy/ry5/kxTP3RcR5ewMzj/BDJxxYRdxYI=";
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;

  ldflags = ["-s" "-w"];
  postInstall = ''
    mv $out/bin/DeepLX $out
    mv $out/DeepLX $out/bin/deeplx
  '';
  meta = with lib; {
    description = "DeepL Free API (No TOKEN required";
    homepage = "https://github.com/OwO-Network/DeepLX";
    license = licenses.mit;
    mainProgram = "deeplx";
  };
}
