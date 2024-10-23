{
  lib,
  buildFishPlugin,
  source,
}:
buildFishPlugin rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  dontCheck = true;
  # 目前测试存在问题，故不进行测试
  # nativeCheckInputs = [git];
  # checkPlugins = [fishtape_3];
  # checkPhase = ''
  #   fishtape tests/fisher.fish
  # '';
  # configurePhase = ''
  #   # sed -i '1s/^/set -gx HOME $PWD\n/' tests/fisher.fish
  #   # sed -i '1s/^/set -gx XDG_CONFIG_HOME $PWD\/.config\n/' tests/fisher.fish
  #   # sed -i '1s/^/set -gx fisher_path $__fish_config_dir\n/' tests/fisher.fish
  #   # sed -i '1s/^/set -gx fish_plugins $__fish_config_dir\/fish_plugins\n/' tests/fisher.fish
  #   sed -i '1s/^/source $PWD\/functions\/fisher.fish || true\n/' tests/fisher.fish
  # '';
  meta = {
    description = "A plugin manager for Fish";
    homepage = "https://github.com/jorgebucaran/fisher";
  };
}
