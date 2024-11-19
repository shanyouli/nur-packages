{
  lib,
  buildGoModule,
  makeWrapper,
  duti,
  source,
  apple-sdk,
  ...
}: let
  newduti = duti.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [apple-sdk];
    configureFlags = [
      "--with-macosx-sdk=${apple-sdk.sdkroot}"
      "--host=x86_64-apple-darwin18"
    ];
  });
in
  buildGoModule rec {
    inherit (source) pname src version;
    vendorHash = "sha256-FD9WC754G/t8BJEyNBzokZePSyduR/ELnG3Dh7boGWs=";

    nativeBuildInputs = [makeWrapper];

    ldflags = ["-s" "-w"];
    doCheck = false;
    postInstall = ''
      wrapProgram $out/bin/dutis \
        --prefix PATH : ${lib.makeBinPath [newduti]}
    '';
    meta = with lib; {
      description = "A command-line tool to select default applications, based on duti";
      homepage = "https://github.com/tsonglew/dutis";
      license = licenses.mit;
      platforms = platforms.darwin;
      mainProgram = "dutis";
    };
  }
