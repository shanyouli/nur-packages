{
  mkDarwinApp,
  source,
  lib,
}:
mkDarwinApp rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  appname = "TimeMachine Exclude";
  # nativeBuildInputs = [makeWrapper];
  # postInstall = ''
  #   makeWrapper $out/Applications/uPic.app/Contents/MacOS/uPic $out/bin/upic
  # '';
  meta = {
    description = "Exclude undesired files (node_modules, target, etc) from your TimeMachine backup. ";
    homepage = "https://github.com/PhotonQuantum/tmexclude";
  };
}
