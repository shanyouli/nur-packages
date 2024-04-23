{
  lib,
  stdenv,
  installShellFiles,
  darwin,
  source,
  runCommandLocal,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit (source) pname version src;

  env = {
    # silence service.h error
    NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";
  };

  nativeBuildInputs = let
    buildSymlinks = runCommandLocal "build-symlinks" {} ''
      mkdir -p $out/bin
      ln -s /usr/bin/{xcrun,codesign,xxd} $out/bin
    '';
  in [installShellFiles buildSymlinks];

  dontConfigure = true;
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    codesign -s - -f ./bin/yabai
    cp -r ./bin $out
    installManPage ./doc/yabai.1
    runHook postInstall
  '';

  postPatch =
    lib.optionalString stdenv.isx86_64
    /*
    bash
    */
    ''
      # aarch64 code is compiled on all targets, which causes our Apple SDK headers to error out.
      # Since multilib doesnt work on darwin i dont know of a better way of handling this.
      substituteInPlace makefile \
      --replace "-arch arm64e" "" \
      --replace "-arch arm64" "" \
      --replace "clang" "${stdenv.cc.targetPrefix}clang"

      # `NSScreen::safeAreaInsets` is only available on macOS 12.0 and above, which frameworks arent packaged.
      # When a lower OS version is detected upstream just returns 0, so we can hardcode that at compiletime.
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
    platforms = lib.platforms.darwin;
    mainProgram = "yabai";
    maintainers = with lib.maintainers; [
      cmacrae
      shardy
      ivar
      khaneliman
    ];
  };
})
