{inputs, ...}: {
  imports = [inputs.pre-commit-hooks-nix.flakeModule];
  perSystem = {...}: {
    pre-commit.check.enable = true;
    pre-commit.settings.excludes = ["generated.nix"];
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      ruff.enable = true;
      deadnix.settings.edit = true;
      deadnix.settings.noLambdaArg = true;
    };
  };
}
