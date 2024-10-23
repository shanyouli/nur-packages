{
  lib,
  buildFishPlugin,
  git,
  fishtape_3,
  source,
}:
buildFishPlugin rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  nativeCheckInputs = [git];
  checkPlugins = [fishtape_3];
  checkPhase = ''
    fishtape tests/*.fish
  '';
  meta = {
    description = "A plugin manager for Fish";
    homepage = "https://github.com/jorgebucaran/fisher";
  };
}
