{inputs, ...}: {
  imports = [inputs.git-hooks-nix.flakeModule];
  perSystem.pre-commit = {
    check.enable = true;
    settings = {
      excludes = ["generated.nix" "bbdown/deps.nix$"];
      hooks = {
        alejandra.enable = true;
        deadnix = {
          enable = true;
          settings = {
            edit = true;
            noLambdaArg = true;
          };
        };
        statix = {
          enable = true;
          settings = {
            ignore = ["orbstack.nix" "generated.nix" "deps.nix"];
          };
        };

        ruff.enable = true;
      };
    };
  };
}
