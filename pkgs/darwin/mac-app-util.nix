{
  lib,
  lispPackagesLite,
  source,
  jq,
  rsync,
  dockutil,
  findutils,
  makeBinaryWrapper,
  ...
}:
with lispPackagesLite;
  lispScript rec {
    inherit (source) src;
    name = pname;
    dependencies = [
      alexandria
      inferior-shell
      cl-interpol
      cl-json
      str
      trivia
    ];
    nativeBuildInputs = [makeBinaryWrapper];
    postInstall = ''
      wrapProgramBinary "$out/bin/${name}" \
                  --suffix PATH : "${lib.makeBinPath [
        dockutil
        rsync
        findutils
        jq
      ]}"
    '';
    installCheckPhase = ''
      $out/bin/${name} --help
    '';
    doInstallCheck = true;
    meta.license = pkgs.lib.licenses.agpl3Only;
  }
