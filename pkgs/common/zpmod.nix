{
  lib,
  stdenv,
  cmake,
  ncurses,
  zsh,
  source,
}:
stdenv.mkDerivation rec {
  inherit (source) pname src version;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses ];

  # zpmod 的 CMakeLists 期望 vendor/zsh/Src/zsh.h 存在；上游以 git submodule 形式
  # 提供，而 nvfetcher 抓取时 fetchSubmodules=false。这里把 nixpkgs zsh 的源码
  # (同为官方 release tarball，含 Src/zsh.h)解压到 vendor/zsh，以满足头文件查找。
  preConfigure = ''
    mkdir -p vendor/zsh
    tar -xf ${zsh.src} -C vendor/zsh --strip-components=1
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DZPMOD_ENABLE_LTO=OFF" # 避免 IPO 在 Nix stdenv 的兼容性抖动
    "-DZPMOD_ENABLE_NATIVE=OFF" # 保持可移植
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
