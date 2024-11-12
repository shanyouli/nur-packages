{
  lib,
  stdenv,
  xcodebuild,
  darwin,
  apple-sdk_15,
  source,
}:
stdenv.mkDerivation rec {
  inherit (source) pname version src;
  nativeBuildInputs = [xcodebuild];
  buildInputs = [apple-sdk_15];
  # FIXME: mkdir -p /var/empty/xxx error
  # see @https://github.com/NixOS/nixpkgs/blob/787264df644cc07c545b1683639ef030cbff4ef4/pkgs/applications/editors/vim/macvim.nix#L114
  # 我不知道为什么构建时，使用 `-derivedDataPath build` 会无法修改 DERIVED_DATA_DIR,
  # 但 pkgs.choose-gui 给了我灵感，可以在 xcodebuild 中指定变量。
  # see @https://github.com/NixOS/nixpkgs/blob/787264df644cc07c545b1683639ef030cbff4ef4/pkgs/by-name/ch/choose-gui/package.nix#L26
  buildPhase = ''
    runHook preBuild
    xcodebuild build -jobs $NIX_BUILD_CORES \
      -configuration Release \
      -project AudioSwitcher.xcodeproj \
      -target SwitchAudioSource \
      -arch ${stdenv.hostPlatform.darwinArch} \
      SYMROOT="./output" \
      DERIVED_DATA_DIR="./deriveddata" \
      # -showBuildSettings
    runHook postBuild
  '';
  installPhase = ''
    install -D -m755 -t $out/bin output/Release/SwitchAudioSource
  '';
  sandboxProfile = ''
    (allow file-read* file-write* process-exec mach-lookup)
    ; block homebrew dependencies
    (deny file-read* file-write* process-exec mach-lookup (subpath "/usr/local") (with no-log))
  '';
  meta = with lib; {
    description = "Change the audio source for Mac OS X from the command line";
    homepage = "https://github.com/deweller/switchaudio-osx";
    license = licenses.mit;
    mainProgram = "switchaudio-osx";
    platforms = platforms.darwin;
  };
}
