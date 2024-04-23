{
  buildDotnetModule,
  lib,
  dotnetCorePackages,
  stdenv,
  zlib,
  icu,
  darwin,
  xcbuild,
  source,
  tree,
}:
buildDotnetModule rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source)
    then source.date
    else lib.removePrefix "v" source.version;
  projectFile = "BBDown.sln";
  nugetDeps = ./deps.nix;
  dotnet-sdk = with dotnetCorePackages; combinePackages [sdk_7_0 sdk_8_0];
  executables = [];
  nativeBuildInputs =
    [stdenv.cc zlib tree]
    ++ lib.optionals stdenv.isLinux [icu]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk_11_0.MacOSX-SDK
      darwin.apple_sdk_11_0.frameworks.CryptoKit
      darwin.apple_sdk_11_0.frameworks.GSS
      xcbuild
    ];
  # 仅在macos上测试
  preConfigure =
    ''
    ''
    + lib.optionalString stdenv.isDarwin ''
      export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
      export LIBRARY_PATH=$LIBRARY_PATH:${darwin.apple_sdk_11_0.MacOSX-SDK}/usr/lib/swift:${darwin.apple_sdk_11_0.MacOSX-SDK}/usr/lib
    ''
    # BUGS: see @  https://github.com/NixOS/nixpkgs/issues/280923
    + lib.optionalString stdenv.isLinux ''
      TOOLS="$HOME/.nuget/packages/microsoft.netcore.app.crossgen2.linux-x64/8.0.3/tools/"
      TOOLS="$TOOLS:$HOME/.nuget/packages/runtime.linux-x64.microsoft.dotnet.ilcompiler/8.0.3/tools/"
      export LD_LIBRARY_PATH="$LDLIBRARY_PATH:$TOOLS"
    '';
  preBuild = ''
    export projectFile=(BBDown)
  '';
  dotnetFlags = ["-p:PublishTrimmed=true"] ++ lib.optionals stdenv.isDarwin ["-p:StripSymbols=false"];
  dotnetInstallFlags = ["--framework=net8.0"];
  selfContainedBuild = true;
  runtimeDeps = [];
  postFixup = ''
    ${lib.optionalString stdenv.isDarwin ''/usr/bin/strip $out/lib/BBDown/BBDown''}
  '';
  meta = with lib; {
    homepage = "https://github.com/nilaoda/BBDown";
    description = "Bilibili Downloader. 一款命令行式哔哩哔哩下载器.";
    license = licenses.mit;
    broken = true;
  };
}
