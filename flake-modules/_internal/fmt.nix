{
  self,
  lib,
  inputs,
  ...
}: {
  perSystem = {
    config,
    system,
    pkgs,
    inputs',
    ...
  }: {
    pre-commit.check.enable = true;
    pre-commit.excludes = ["generated.nix"];
    pre-commit.hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      ruff.enable = true;
      deadnix.settings.edit = true;
      deadnix.settings.noLambdaArg = true;
    };
  };
}
