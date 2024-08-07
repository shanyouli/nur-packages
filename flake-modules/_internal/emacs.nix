{
  lib,
  withSystem,
  ...
}: {
  flake.overlays.emacs = final: prev:
    withSystem prev.stdenv.hostPlatform.system ({config, ...}: {
      emacs = config.packages.emacs;
      emacsGit = config.packages.emacsGit;
    });

  perSystem = {
    inputs',
    pkgs,
    ...
  }: let
    srcs = (import ../../_sources/generated.nix) {
      inherit (pkgs) fetchurl fetchFromGitHub fetchgit dockerTools;
    };
    mkEmacs = pkg: version: let
      basePkg = pkg.override {
        withImageMagick = true; # org-mode 控制图片大小
        withGTK3 = ! pkgs.stdenvNoCC.isDarwin;
        withXwidgets = ! pkgs.stdenvNoCC.isDarwin;
        # @see https://emacs-china.org/t/native-compilation/23316/73
        # 目前没有发现明显的提升
        # withNativeCompilation = true;
      };
    in
      basePkg.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ lib.optionals pkgs.stdenvNoCC.isDarwin [
            srcs."emacs${version}.role-patch".src
            srcs."emacs${version}.system-appearance".src
            srcs."emacs${version}.round-undecorated-frame".src
          ]
          ++ lib.optionals (pkgs.stdenvNoCC.isDarwin && (version == "29")) [
            srcs."emacs${version}.no-frame-refocus-cocoa".src
            srcs."emacs${version}.poll".src
          ];
        buildInputs = (old.buildInputs or []) ++ lib.optionals pkgs.stdenvNoCC.isDarwin [pkgs.darwin.apple_sdk.frameworks.WebKit];
        configureFlags = (old.configureFlags or []) ++ ["--enable-check-lisp-object-type"] ++ lib.optionals pkgs.stdenvNoCC.isDarwin ["--with-xwidgets"];
        CFLAGS = "-DMAC_OS_X_VERSION_MAX_ALLOWED=110203 -g -O2";
      });
  in {
    packages.emacsGit = mkEmacs inputs'.emacs-overlay.packages.emacs-git "30";
    packages.emacs = mkEmacs inputs'.emacs-overlay.packages.emacs-unstable "29";
  };
}
