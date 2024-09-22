{
  lib,
  buildGoModule,
  source,
  go,
}:
buildGoModule rec {
  inherit (source) pname src;
  vendorHash = "sha256-8oqIIYJhPzJtQLALzKbbhbrw7Xe0JmKqzRDRpcLyOmA=";
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;

  ldflags = ["-s" "-w"];
  postInstall = ''
    mv $out/bin/DeepLX $out
    mv $out/DeepLX $out/bin/deeplx
  '';
  preBuild = ''
    ls -al
    sed -i 's/^go 1\(\.[0-9]\+\)\{1,2\}$/go ${go.version}/' go.mod
  '';
  meta = with lib; {
    description = "DeepL Free API (No TOKEN required";
    homepage = "https://github.com/OwO-Network/DeepLX";
    license = licenses.mit;
    mainProgram = "deeplx";
  };
}
