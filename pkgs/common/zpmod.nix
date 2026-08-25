{
  lib,
  stdenv,
  cmake,
  ncurses,
  # zsh,
  source,
}:
stdenv.mkDerivation rec {
  inherit (source) pname src version;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses ];

  # zpmod 的 CMakeLists 期望 vendor/zsh/Src/zsh.h 存在；上游以 git submodule 形式
  # 提供，而 nvfetcher 抓取时 fetchSubmodules=false。这里把 nixpkgs zsh 的源码
  # (同为官方 release tarball，含 Src/zsh.h)解压到 vendor/zsh，以满足头文件查找。
  # preConfigure = ''
  #   mkdir -p vendor/zsh
  #   tar -xf ${zsh.src} -C vendor/zsh --strip-components=1
  # '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DZPMOD_ENABLE_LTO=OFF" # 避免 IPO 在 Nix stdenv 的兼容性抖动
    "-DZPMOD_ENABLE_NATIVE=OFF" # 保持可移植
  ];

  # zpmod vendored 的 zsh 头文件/自身源码在新版 stdenv 编译器下有两处会被默认升级为
  # error 的诊断，上游未修，先统一降回 warning 以恢复构建:
  #
  # 1) -Wincompatible-pointer-types (GCC 15 起默认 error)
  #    vendor/zsh/Src/zsh_system.h:764 把 memmove 重定义为 bcopy 宏，在
  #    src/core/source.c:244 产生 char* <- Wordcode(unsigned int*) 的不兼容指针赋值。
  #
  # 2) -Wimplicit-function-declaration (GCC 14 起默认 error, clang 亦然)
  #    src/core/source_hot.c:144 调用 zsh 内部函数 execstring 但未引入其声明。
  #    运行时该符号由 zsh 模块系统解析，降级为 warning 不影响 zmodload 加载。
  NIX_CFLAGS_COMPILE = [
    "-Wno-error=incompatible-pointer-types"
    "-Wno-error=implicit-function-declaration"
  ];

  doCheck = false;

  # 安装交给 CMake 的 install(TARGETS zpmod ...) 与 install(FILES .../_zpmod)：
  # 默认落到 $out/lib/zsh/site-modules/zpmod.so 与 $out/share/zsh/site-functions/_zpmod，
  # 不再手写 installPhase。

  meta = with lib; {
    description = "Zsh module transparently and automatically compiles sourced scripts";
    homepage = "https://github.com/z-shell/zpmod";
    license = licenses.gpl2; # FIXME: nix-init did not found a license
    mainProgram = "zpmod";
    platforms = platforms.all;
  };
}
