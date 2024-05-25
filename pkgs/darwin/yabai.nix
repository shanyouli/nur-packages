{
  lib,
  stdenv,
  overrideSDK,
  installShellFiles,
  darwin,
  xcodebuild,
  xxd,
  sources,
}: let
  inherit
    (darwin.apple_sdk_11_0.frameworks)
    Carbon
    Cocoa
    ScriptingBridge
    SkyLight
    ;

  stdenv' =
    if stdenv.isDarwin
    then overrideSDK stdenv "11.0"
    else stdenv;
  source =
    if stdenv.isx86_64
    then sources.yabai
    else sources.yabai-bin;
in
  stdenv'.mkDerivation (finalAttrs: {
    inherit (source) pname version src;
    env = {
      # silence service.h error
      NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";
    };

    nativeBuildInputs =
      [installShellFiles]
      ++ lib.optionals stdenv.isx86_64 [
        xcodebuild
        xxd
      ];

    buildInputs = lib.optionals stdenv.isx86_64 [
      Carbon
      Cocoa
      ScriptingBridge
      SkyLight
    ];

    dontConfigure = true;
    dontBuild = stdenv.isAarch64;
    enableParallelBuilding = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share/icons/hicolor/scalable/apps}

      cp ./bin/yabai $out/bin/yabai
      ${lib.optionalString stdenv.isx86_64 "cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg"}
      installManPage ./doc/yabai.1

      runHook postInstall
    '';

    postPatch =
      lib.optionalString stdenv.isx86_64 # bash
      
      ''
        # aarch64 code is compiled on all targets, which causes our Apple SDK headers to error out.
        # Since multilib doesn't work on darwin i dont know of a better way of handling this.
        substituteInPlace makefile \
        --replace "-arch arm64e" "" \
        --replace "-arch arm64" "" \
        --replace "clang" "${stdenv.cc.targetPrefix}clang"

        # `NSScreen::safeAreaInsets` is only available on macOS 12.0 and above, which frameworks aren't packaged.
        # When a lower OS version is detected upstream just returns 0, so we can hardcode that at compile time.
        # https://github.com/koekeishiya/yabai/blob/v4.0.2/src/workspace.m#L109
        substituteInPlace src/workspace.m \
        --replace 'return screen.safeAreaInsets.top;' 'return 0;'
      '';

    meta = {
      description = "A tiling window manager for macOS based on binary space partitioning";
      longDescription = ''
        yabai is a window management utility that is designed to work as an extension to the built-in
        window manager of macOS. yabai allows you to control your windows, spaces and displays freely
        using an intuitive command line interface and optionally set user-defined keyboard shortcuts
        using skhd and other third-party software.
      '';
      homepage = "https://github.com/koekeishiya/yabai";
      changelog = "https://github.com/koekeishiya/yabai/blob/v${finalAttrs.version}/CHANGELOG.md";
      license = lib.licenses.mit;
      broken = ! stdenv.isDarwin;
      mainProgram = "yabai";
    };
  })
