{
  lib,
  stdenv,
  apple-sdk_15,
  bintools-unwrapped,
  cups,
  installShellFiles,
  llvmPackages,
  xxd,
  versionCheckHook,
  source,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit (source) pname src;
  version = lib.removePrefix "v" source.version;

  nativeBuildInputs = [
    installShellFiles
    xxd
  ];

  buildInputs = [ apple-sdk_15 ];

  # 上游 makefile 的 all 目标把 clean-build 和链接放在同一层，并行 make 会互相踩踏
  enableParallelBuilding = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/icons/hicolor/scalable/apps}
    cp ./bin/yabai $out/bin/yabai
    cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg
    installManPage ./doc/yabai.1

    runHook postInstall
  '';

  # 上游 makefile 用 xcrun clang 产出 x86_64 + arm64/arm64e 的通用二进制。
  # 沙箱里没有 xcrun，且 cc-wrapper 无法指定 -arch arm64e，因此：
  # 主二进制收敛到宿主架构（顺带去掉非确定性的 LC_UUID），
  # 只有脚本插件（必须 arm64e）留给 preBuild 用未包装的 clang 编译。
  postPatch =
    let
      arch = stdenv.hostPlatform.darwinArch;
      # 脚本插件要注入 arm64e 的系统进程
      archSA = "${arch}${lib.optionalString stdenv.hostPlatform.isAarch64 "e"}";
      clangFlags = lib.concatStringsSep " " [
        "-isystem $(SDKROOT)/usr/include"
        "-isystem ${llvmPackages.libclang.lib}/lib/clang/*/include"
        "-isystem ${lib.getDev cups}/include"
        "-F$(SDKROOT)/System/Library/Frameworks"
        "-L$(SDKROOT)/usr/lib"
      ];
    in
    ''
      substituteInPlace makefile \
        --replace-fail "-arch x86_64 -arch arm64e" "-arch ${archSA}" \
        --replace-fail "-arch x86_64 -arch arm64" "-arch ${arch} -Wl,-no_uuid" \
        --replace-fail 'xcrun clang' 'clang ${clangFlags}'
    '';

  # 未包装的 clang 找不到汇编器/链接器和 SDK 头文件，需显式给 PATH 与包含路径
  preBuild = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    make ./src/osax/payload_bin.c ./src/osax/loader_bin.c \
      "PATH=${bintools-unwrapped}/bin:${llvmPackages.clang-unwrapped}/bin:$PATH"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = with lib; {
    description = "Tiling window manager for macOS (maintained macOS 27 fork of yabai)";
    longDescription = ''
      A maintained fork of asmvik/yabai that works on macOS 27: instant space switching
      with SIP on or off. Commands and configuration format match upstream, and the
      upstream project provides signed and notarized release builds.
    '';
    homepage = "https://github.com/Christian-SC26/yabai";
    changelog = "https://github.com/Christian-SC26/yabai/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "yabai";
  };
})
