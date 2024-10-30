{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
        flake-compat.follows = "flake-compat";
      };
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
        flake-utils.follows = "flake-utils";
      };
    };

    # @see https://github.com/nix-community/emacs-overlay/issues/275
    # emacs-src.url = "github:emacs-mirror/emacs/emacs-29";
    # emacs-src.flake = false;
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs: let
    inherit (import ./nix/lib/modules.nix {inherit (nixpkgs) lib;}) moduleFilesRec;
    this = import ./pkgs;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = moduleFilesRec ./nix;
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
