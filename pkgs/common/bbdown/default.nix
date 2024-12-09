{
  buildDotnetModule,
  lib,
  dotnetCorePackages,
  stdenv,
  zlib,
  icu,
  apple-sdk_13,
  xcbuild,
  darwin,
  source,
  tree,
}:
buildDotnetModule rec {
  inherit (source) pname src;
  version =
    if lib.hasPrefix "unstable" source.version
    then "9.9-${source.version}"
    else source.version;
  # projectFile = "BBDown.sln";
  projectFile = "BBDown/BBDown.csproj";
  nugetDeps = ./deps.nix;
  dotnet-sdk = with dotnetCorePackages; combinePackages [sdk_9_0]; #  sdk_8_0
  useDotnetFromEnv = true;
  executables = ["BBDown"];
  nativeBuildInputs =
    [stdenv.cc zlib tree]
    ++ lib.optionals stdenv.hostPlatform.isLinux [icu]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_13
      darwin.ICU
      xcbuild
    ];
  # 仅在macos上测试
  # preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
  #     export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
  #     export LIBRARY_PATH=$LIBRARY_PATH:${darwin.apple_sdk.MacOSX-SDK}/usr/lib/:${darwin.apple_sdk.MacOSX-SDK}/usr/lib/swift/
  #   '';
  # BUGS: see @  https://github.com/NixOS/nixpkgs/issues/280923
  # + lib.optionalString stdenv.hostPlatform.isLinux ''
  #   TOOLS="$HOME/.nuget/packages/microsoft.netcore.app.crossgen2.linux-x64/${dotnetCorePackages.runtime_8_0.version}/tools/"
  #   TOOLS="$TOOLS:$HOME/.nuget/packages/runtime.linux-x64.microsoft.dotnet.ilcompiler/${dotnetCorePackages.runtime_8_0.version}/tools/"
  #   export LD_LIBRARY_PATH="$LDLIBRARY_PATH:$TOOLS"
  # '';
  preBuild = ''
    export projectFile=(BBDown)
  '';
  dotnetFlags = ["-p:PublishTrimmed=true"] ++ lib.optionals stdenv.hostPlatform.isDarwin ["-p:StripSymbols=false"];
  dotnetInstallFlags = ["--framework=net9.0"];
  selfContainedBuild = true;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  runtimeDeps = [];
  postFixup = ''
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''/usr/bin/strip $out/lib/BBDown/BBDown''}
    ln -s ~/.config/BBDown/BBDown.data $out/lib/BBDown/BBDown.data || true
  '';
  meta = with lib; {
    homepage = "https://github.com/nilaoda/BBDown";
    description = "Bilibili Downloader. 一款命令行式哔哩哔哩下载器.";
    license = licenses.mit;
    # broken = stdenv.hostPlatform.isDarwin;
    # broken = true;
    # platforms = platforms.linux;
  };
}
