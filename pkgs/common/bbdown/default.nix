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
  stdenvNoCC,
}: let
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system;
in
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
      [stdenv.cc zlib]
      ++ lib.optionals stdenv.hostPlatform.isLinux [icu]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        apple-sdk_13
        darwin.ICU
        xcbuild
      ];
    preBuild = ''
      export projectFile=(BBDown)
    '';
    dotnetFlags =
      [
        "-p:PublishTrimmed=true"
        # for some reason this is set to win-x64 in the project files
        "-p:RuntimeIdentifier=${rid}"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin ["-p:StripSymbols=false"];
    selfContainedBuild = true;
    dotnet-runtime = dotnetCorePackages.runtime_9_0;
    runtimeDeps = [];
    meta = with lib; {
      homepage = "https://github.com/nilaoda/BBDown";
      description = "Bilibili Downloader. 一款命令行式哔哩哔哩下载器.";
      license = licenses.mit;
      # broken = stdenv.hostPlatform.isDarwin;
      # broken = true;
      # platforms = platforms.linux;
    };
  }
