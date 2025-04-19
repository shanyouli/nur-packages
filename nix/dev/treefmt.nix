{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { config, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        settings.global.excludes = [
          "*.gpg"
          "*.lock"
          "**/generated.nix"
          "**/bbdown/deps.nix"
        ];

        programs = {
          # nix format
          statix.enable = true; # nix static analysis
          deadnix = {
            no-lambda-arg = true;
            enable = true;
          };
          nixfmt = {
            enable = true;
            strict = true;
            width = 100;
          };
          # python
          ruff.enable = true;
          ruff.check = true;
        };
      };
      formatter = config.treefmt.build.wrapper;
    };
}
