{
  perSystem = {...}: {
    pre-commit.check.enable = true;
    pre-commit.settings.excludes = ["generated.nix" "bbdown/deps.nix"];
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      ruff.enable = true;
      deadnix.settings.edit = true;
      deadnix.settings.noLambdaArg = true;
    };
  };
}
