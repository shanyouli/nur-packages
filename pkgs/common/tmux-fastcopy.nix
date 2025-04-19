{
  lib,
  buildGoModule,
  source,
}:
buildGoModule rec {
  inherit (source) pname src;
  vendorHash = "sha256-Jcx9/qJKR4q1EYUu6NsNkakJS/qtQLlhys0GKx5BLQk=";
  subPackages = [ "." ];
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;

  ldflags = [
    "-s"
    "-w"
  ];
  # postInstall = ''
  #   mv $out/bin/DeepLX $out
  #   mv $out/DeepLX $out/bin/deeplx
  # '';
  checkFlags =
    let
      skippedTests = [ "TestArgAction_RegexesEnv" ];
    in
    [ "--skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];
  meta = with lib; {
    description = "easymotion-style text copying for tmux.";
    homepage = "https://github.com/abhinav/tmux-fastcopy/tree/main";
    license = licenses.gpl2;
    mainProgram = "tmux-fastcopy";
  };
}
