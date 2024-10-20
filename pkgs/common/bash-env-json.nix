{
  lib,
  bash,
  coreutils,
  gnused,
  jq,
  makeWrapper,
  runCommand,
  source,
}: let
  inherit (source) pname;
in
  runCommand pname {
    inherit (source) pname src;
    version =
      if (builtins.hasAttr "date" source)
      then source.date
      else lib.removePrefix "v" source.version;
    buildInputs = [bash jq makeWrapper];
    dontUnpack = true;
    dontInstall = true;
    meta = with lib; {
      description = " export of Bash environment as JSON";
      homepage = "https://github.com/tesujimath/bash-env-json";
      platforms = platforms.all;
    };
  } ''
     mkdir -p $out/bin
     mv -vf $src $out/bin/${pname}
     patchShebangs $out/bin/${pname}
    wrapProgram $out/bin/${pname} --prefix PATH : ${lib.makeBinPath [coreutils gnused jq]}
  ''