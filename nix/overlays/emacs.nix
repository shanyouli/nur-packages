{
  lib,
  withSystem,
  self,
  ...
}:
{
  flake.overlays.emacs =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { config, ... }:
      {
        inherit (config.packages) emacs emacs-git;
      }
    );

  perSystem =
    { inputs', pkgs, ... }:
    let
      srcs = self.lib.nurSources pkgs;
      mkEmacs =
        pkg: version:
        let
          basePkg = pkg.override {
            withImageMagick = true; # org-mode 控制图片大小
            withGTK3 = !pkgs.stdenvNoCC.isDarwin;
            # see: https://github.com/NixOS/nixpkgs/pull/344631
            # An incompatibility with newer versions of webkit2gtk was revealed
            # 和较新的 webkit2gtk 不兼容，临时禁用它
            withXwidgets = (!pkgs.stdenvNoCC.isDarwin) && ((lib.strings.toInt version) < 30);
            # @see https://emacs-china.org/t/native-compilation/23316/73
            # 目前没有发现明显的提升
            # BUG: see@https://github.com/NixOS/nixpkgs/issues/395169
            withNativeCompilation = !pkgs.stdenv.hostPlatform.isDarwin;
          };
        in
        basePkg.overrideAttrs (old: {
          # preConfigure = old.preConfigure or "" + ''
          #     export CFLAGS+=" -DMAC_OS_X_VERSION_MAX_ALLOWED=110203 -O2 -g"
          #   '';
          patches =
            (old.patches or [ ])
            ++ (
              if pkgs.stdenvNoCC.isDarwin then
                [
                  srcs."emacs${version}.role-patch".src
                  srcs."emacs${version}.system-appearance".src
                  srcs."emacs${version}.round-undecorated-frame".src
                ]
                ++ lib.optionals (version == "29") [ srcs."emacs${version}.no-frame-refocus-cocoa".src ]
              else
                [ ]
            );
          configureFlags =
            (old.configureFlags or [ ])
            ++ [ "--enable-check-lisp-object-type" ]
            ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
              "--with-xwidgets"
              "CFLAGS=-DMAC_OS_X_VERSION_MAX_ALLOWED=101201"
              "CFLAGS=-DMAC_OS_X_VERSION_MIN_REQUIRED=101201"
              "CFLAGS=-O2"
              "CFLAGS=-g"
            ];
          # BUG: 设置 CFLAGS 会导致 darwin 编译时，无法发现 AppKit，自从 nixos24.11 后
        });
      emacs-version = lib.versions.major inputs'.emacs-overlay.packages.emacs-unstable.version;
      emacs-git-version = builtins.toString ((lib.strings.toInt emacs-version) + 1);
    in
    {
      packages = {
        emacs-git = mkEmacs inputs'.emacs-overlay.packages.emacs-git emacs-git-version;
        emacs = mkEmacs inputs'.emacs-overlay.packages.emacs-unstable emacs-version;
        emacs-stable = mkEmacs pkgs.emacs (lib.versions.major pkgs.emacs.version);
        # emacs-igc = mkEmacs inputs'.emacs-overlay.packages.emacs-igc emacs-git-version;
      };
    };
}
