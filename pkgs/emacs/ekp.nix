{
  lib,
  emacs,
  melpaBuild,
  source,
  stdenv,
}:
let
  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in
melpaBuild {
  inherit (source) pname version src;
  ename = "ekp";
  # (:defaults) 的字符串 glob 会把文件平铺到包根，词典需保留 dictionaries/ 子目录结构，
  # 故用 package-build 的 (SUBDIR GLOB...) 形式安装到 tar 的 dictionaries/ 下
  files = ''
    (:defaults ("dictionaries" "dictionaries/*.dic"))
  '';
  # 参考 nixpkgs liberime 的做法：构建期编译可选的 C 加速模块。
  # 对应上游 native/Makefile 的 portable profile，显式传入 emacs-module.h 路径。
  postBuild = ''
    make -C native CC=$CC \
      CFLAGS="-std=c11 -O3 -fPIC -D_POSIX_C_SOURCE=200809L -I${emacs}/include" \
      LDFLAGS="-shared -lpthread -lm"
  '';
  # ekp.el 运行时经 M-x ekp-c-module-load 从 <pkg>/native/ekp${libExt} 加载模块。
  # 先解析已存在的包目录（elpa 下唯一）再 install -D 创建 native/ 子目录，
  # 避免对尚不存在的 native/ 多级 glob 被 nullglob 空展开
  postInstall = ''
    for pkgdir in $out/share/emacs/site-lisp/elpa/ekp-*/; do
      install -Dm444 native/ekp${libExt} "$pkgdir/native/ekp${libExt}"
    done
  '';
  # Package-Requires: ((emacs "29.1"))，无外部 emacs 包依赖
  meta = {
    homepage = "https://github.com/emacs-taf/ekp";
    description = "Knuth-Plass line breaking with CJK support";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
