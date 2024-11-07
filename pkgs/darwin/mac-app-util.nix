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
    name = source.pname;
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
    meta.license = lib.licenses.agpl3Only;
    # see@https://github.com/NixOS/nixpkgs/issues/327836
    meta.broken = true;
  }
