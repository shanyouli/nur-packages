{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs: let
    this = import ./pkgs;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.pre-commit-hooks-nix.flakeModule
        ./flake-modules/_internal/commands.nix
        ./flake-modules/_internal/fmt.nix
      ];
      debug = true;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      flake = {
        overlay = self.overlays.default;
        overlays = {
          default = this.overlay;
        };
      };
      perSystem = {
        system,
        pkgs,
        ...
      }: rec {
        _module.args.pkgs = import inputs.nixpkgs {
          overlays = [self.overlays.default];
          inherit system;
          config.allowUnfree = true;
        };
        packages = this.packages pkgs;
      };
    };
}
