# 打包模板大全

所有模板基于本仓库 `pkgs/` 实际文件提炼，来源文件标注在标题处。
通用惯例（version 表达式、meta 四项、平台条件依赖）见 SKILL.md §5，此处不重复。

---

## 1. Rust CLI（来源：pkgs/common/manix.nix、ewt-rs.nix）

```nix
{
  lib,
  rustPlatform,
  source,
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  cargoLock = source.cargoLock."Cargo.lock";

  meta = with lib; {
    description = "一句话描述（抄上游 README）";
    homepage = "https://github.com/owner/repo";
    license = licenses.mit;
    mainProgram = "binary-name";
  };
}
```

要点：
- `cargoLock` 来自 nvfetcher 的 `cargo_lock = ["Cargo.lock"]`，键名是 lock 文件路径。
- 需要 bindgen（依赖 C 库声明的 crate）时加 `nativeBuildInputs = [ rustPlatform.bindgenHook ];`。

## 2. Rust + openssl + macOS SDK（来源：pkgs/common/seam.nix）

```nix
{
  lib,
  rustPlatform,
  pkg-config,
  stdenv,
  openssl,
  apple-sdk,
  source,
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ apple-sdk ];
  env = {
    OPENSSL_NO_VENDOR = true; # 禁用 openssl-sys 源码 vendoring，用系统 openssl
  };
  doCheck = false;
  cargoLock = source.cargoLock."Cargo.lock";
  meta = with lib; {
    description = "...";
    homepage = "https://github.com/Borber/seam";
    license = with licenses; [ mit unlicense ]; # 双许可用列表
    mainProgram = "seam";
  };
}
```

## 3. Rust workspace 多 bin（来源：pkgs/common/seam.nix cargoBuildFlags）

```nix
  cargoBuildFlags = [ "--package" "seam" ];
  cargoTestFlags = [ "-p" "seam" "--bin" "seam" ];
```

## 4. Tauri 项目（来源：pkgs/common/cc-switch.nix）

```nix
{
  rustPlatform,
  source,
  lib,
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."./src-tauri/Cargo.lock"; # 注意路径前缀
  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";
  doCheck = false;
  meta = with lib; {
    description = "...";
    homepage = "https://github.com/saladday/cc-switch-cli";
    license = licenses.mit;
    mainProgram = "cc-switch";
    platforms = platforms.unix;
  };
}
```

## 5. Rust MSRV 不够时用 unstable 工具链（来源：pkgs/common/fav.nix）

```nix
{
  lib,
  stdenv,
  unstable,   # 注入的 nixpkgs-unstable 包集
  pkg-config,
  openssl,
  ffmpeg,
  apple-sdk,
  source,
}:
unstable.rustPlatform.buildRustPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  cargoLock = source.cargoLock."Cargo.lock";
  postConfigure = ''
    cargo metadata --offline
  '';
  nativeBuildInputs = [ pkg-config unstable.rustPlatform.bindgenHook ];
  buildInputs = [ openssl ffmpeg ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk ];
  doCheck = false;
  env = {
    OPENSSL_NO_VENDOR = true;
  };
  meta = with lib; { /* ... */ };
}
```

## 6. Go CLI（来源：pkgs/common/deeplx.nix、tmux-fastcopy.nix）

```nix
{
  lib,
  buildGoModule,
  source,
}:
buildGoModule rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # 先占位，构建后替换
  subPackages = [ "." ]; # 或 [ "cmd/sing-box" ]
  ldflags = [
    "-s"
    "-w"
  ];
  meta = with lib; {
    description = "...";
    homepage = "https://github.com/owner/repo";
    license = licenses.mit;
    mainProgram = "name";
  };
}
```

变体：
- **指定 Go 版本**：形参加 `go_1_27`，改用 `(buildGoModule.override { go = go_1_27; }) rec { ... }`。
- **版本注入**：`ldflags = [ "-s" "-w" "-X=github.com/sagernet/sing-box/constant.Version=${version}" ];`
- **build tags**：`tags = [ "with_quic" "with_grpc" ... ];`
- **go.mod 版本过高**：`preBuild = '' sed -i 's/^go 1\(\.[0-9]\+\)\{1,2\}$/go ${go.version}/' go.mod '';`（deeplx）
- **跳过个别测试**：
  ```nix
  checkFlags = let skipped = [ "TestArgAction_RegexesEnv" ]; in
    [ "--skip=^${builtins.concatStringsSep "$|^" skipped}$" ];
  ```

## 7. Go + 补全 + systemd 单元（来源：pkgs/common/singboxp.nix）

```nix
{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  buildPackages,
  coreutils,
  source,
}:
buildGoModule rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  vendorHash = "sha256-...";
  subPackages = [ "cmd/sing-box" ];
  nativeBuildInputs = [ installShellFiles ];
  ldflags = [ "-s" "-w" "-X=...Version=${version}" ];
  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages; # 交叉编译时用模拟器跑目标二进制
    in
    ''
      installShellCompletion --cmd sing-box \
        --bash <(${emulator} $out/bin/sing-box completion bash) \
        --fish <(${emulator} $out/bin/sing-box completion fish) \
        --zsh  <(${emulator} $out/bin/sing-box completion zsh)
      substituteInPlace release/config/sing-box{,@}.service \
        --replace-fail "/usr/bin/sing-box" "$out/bin/sing-box" \
        --replace-fail "/bin/kill" "${coreutils}/bin/kill"
      install -Dm444 -t "$out/lib/systemd/system/" release/config/sing-box{,@}.service
    '';
  meta = with lib; { /* ... */ };
}
```

## 8. Python CLI 应用（来源：pkgs/python/sd.nix）

```nix
{
  lib,
  installShellFiles,
  source,
  stdenv,
  darwin,
  typer,
  wcwidth,
  buildPythonApplication,
  uv-build,
}:
buildPythonApplication rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  pyproject = true;
  build-system = [ uv-build ]; # 按 pyproject.toml [build-system] requires 填
  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.ps ];
  propagatedBuildInputs = [ typer wcwidth ]; # 运行时 import 的依赖
  postInstall = ''
    installShellCompletion --cmd sd \
      --bash <($out/bin/sd completion show bash) \
      --zsh <($out/bin/sd completion show zsh) \
      --fish <($out/bin/sd completion show fish)
  '';
  meta = with lib; {
    description = "...";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
```

## 9. Python 库（来源：pkgs/python/musicdl.nix、alive-progress.nix）

```nix
{
  lib,
  python3Packages,
  source,
}:
let
  inherit (python3Packages)
    buildPythonPackage
    click
    requests
    /* 按 import 逐个列出 */;
in
buildPythonPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  propagatedBuildInputs = [ click requests ];
  doCheck = false;
  format = "setuptools"; # pyproject.toml 用 pyproject = true + build-system
  meta = with lib; {
    description = "...";
    homepage = "https://github.com/CharlesPikachu/musicdl";
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
```

要点：python 目录的包自动注入 `python3Packages`（装配层还会 `toPythonModule` 包装），
依赖从 `python3Packages` 取，不要写 `python3Packages.xxx` 全名。

## 10. 字体包（来源：pkgs/common/maple-mono.nix）

```nix
{
  lib,
  stdenvNoCC,
  source,
  p7zip,   # zip 用 unzip
}:
stdenvNoCC.mkDerivation {
  inherit (source) src pname version;
  sourceRoot = "."; # 压缩包无顶层目录时必须
  nativeBuildInputs = [ p7zip ];
  unpackPhase = ''
    mkdir -p $out/tmp
    7z x -y $src -o$out/tmp
    pushd $out/tmp
    find -name \*.ttf -exec mkdir -p $out/share/fonts/truetype \; -exec mv {} $out/share/fonts/truetype \;
    popd
    rm -rf $out/tmp
  '';
  dontInstall = true;
  meta = with lib; {
    description = "...";
    homepage = "https://github.com/shanyouli/maple-mono-action";
    platforms = platforms.all;
  };
}
```

简化版（tar 解包，来源 nixpkgs maple-font）：

```nix
  installPhase = ''
    find . -name '*.ttf'   -exec install -Dt $out/share/fonts/truetype {} \;
    find . -name '*.otf'   -exec install -Dt $out/share/fonts/opentype {} \;
    find . -name '*.woff2' -exec install -Dt $out/share/fonts/woff2 {} \;
  '';
```

## 11. 数据/配置文件包（来源：pkgs/common/rime-ice.nix）

```nix
{
  source,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  inherit (source) pname src version;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/rime-data
    rm -rf ./others ./.github
    cp -r ./* $out/share/rime-data/
    runHook postInstall
  '';
  meta = with lib; {
    description = "Rime 配置:雾凇拼音";
    homepage = "https://dvel.me/posts/rime-ice/";
    license = lib.licenses.gpl3Only;
  };
}
```

## 12. runCommand 轻量包（来源：pkgs/common/userChromeJS.nix、flexfox.nix）

```nix
{
  runCommand,
  lib,
  source,
}:
runCommand "firefox-userchromejs"
  {
    inherit (source) pname src;
    version =
      if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
    meta = with lib; {
      homepage = "https://github.com/benzBrake/userChrome.js-Loader";
      description = "Firefox scripts";
    };
  }
  ''
    mkdir -p $out
    cp -rv $src/src/profile/chrome/* $out/
  ''
```

带 PATH 包装的脚本包（来源：bash-env-json.nix）：

```nix
{
  lib,
  bash,
  coreutils,
  gnused,
  jq,
  makeWrapper,
  runCommand,
  source,
}:
runCommand source.pname
  {
    inherit (source) pname src;
    version = /* 同上 */;
    buildInputs = [ bash jq makeWrapper ];
    meta = with lib; { /* ... */ };
  }
  ''
    mkdir -p $out/bin
    cp -rv $src $out/bin/${source.pname}
    chmod +x $out/bin/${source.pname}
    patchShebangs $out/bin/${source.pname}
    wrapProgram $out/bin/${source.pname} --prefix PATH : ${
      lib.makeBinPath [ coreutils gnused jq ]
    }
  ''
```

## 13. macOS 预编译 CLI（来源：pkgs/darwin/pngpaste.nix、nowplaying-cli.nix）

```nix
{
  stdenv,
  apple-sdk,
  lib,
  source,
}:
stdenv.mkDerivation rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  buildInputs = [ apple-sdk ];
  installPhase = ''
    mkdir -p $out/bin
    cp pngpaste $out/bin/   # 上游仓库直接带编译好的二进制
  '';
  meta = with lib; {
    description = "...";
    homepage = "https://github.com/jcsalterego/pngpaste";
    platforms = platforms.darwin;
    license = licenses.gpl3;
  };
}
```

## 14. macOS .app 安装（来源：pkgs/darwin/firefox/default.nix + nix/plib/build-support/mkDarwinApp.nix）

```nix
{
  mkDarwinApp,
  sources,
  lib,
  fetchurl,
  ...
}:
mkDarwinApp rec {
  pname = "firefox";
  version = "130.0";
  src = fetchurl { url = "..."; sha256 = "..."; }; # 或 inherit (source) src;
  appname = "Firefox"; # .app 内实际名字，默认同 pname
  postInstall = ''
    # 可选：往 .app 内塞文件
  '';
  meta = {
    description = "...";
    homepage = "...";
  };
}
```

mkDarwinApp 自动处理 dmg/zip/7z/tar.gz 解包与 .app 复制到 `$out/Applications/`。
带 `sources.json` 的变体见 `pkgs/darwin/firefox/default.nix`。

## 15. Firefox 扩展（来源：pkgs/firefox-addons/darkreader.nix）

```nix
{
  mkFirefoxAddon,
  lib,
  source,
}:
mkFirefoxAddon {
  inherit (source) pname version src;
  addonId = "addon@darkreader.org"; # 从 .xpi 内 manifest.json 的 browser_specific_settings 取
  meta = with lib; {
    homepage = "https://darkreader.org/";
    description = "...";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
```

## 16. Emacs 包（来源：pkgs/emacs/emt.nix、emacs-reader.nix）

```nix
{
  source,
  melpaBuild,
  lib,
}:
melpaBuild {
  inherit (source) pname version src;
  ename = "emt"; # Emacs 内的包名（M-x package-install 用名）
  files = ''
    (:defaults )
  '';
  meta = {
    homepage = "https://github.com/roife/emt";
    description = "...";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
```

带 C 扩展编译的变体（emacs-reader.nix）：加 `nativeBuildInputs = [ pkg-config ]`、
`buildInputs = [ mupdf-headless ]`、`preBuild` 里 `make clean all CC=$CC USE_PKGCONFIG=yes`、
`postInstall` 安装 `.so` 到 `$out/share/emacs/site-lisp/elpa/<ename>-<version>/`。

## 17. Fish 插件（来源：pkgs/fish/fisher.nix）

```nix
{
  lib,
  buildFishPlugin,
  source,
}:
buildFishPlugin rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  dontCheck = true;
  meta = {
    description = "A plugin manager for Fish";
    homepage = "https://github.com/jorgebucaran/fisher";
  };
}
```

## 18. Lua 包（来源：pkgs/lua/jeejah.nix）

```nix
{
  fetchurl,
  fetchFromGitLab,
  luaOlder,
  luasocket,
  buildLuarocksPackage,
}:
buildLuarocksPackage {
  pname = "jeejah";
  version = "0.3.2-1";
  knownRockspec =
    (fetchurl {
      url = "https://loadk.com/luarocks/jeejah-0.3.2-1.rockspec";
      sha256 = "...";
    }).outPath;
  src = fetchFromGitLab {
    owner = "technomancy";
    repo = "jeejah";
    rev = "0.3.2";
    hash = "sha256-...";
  };
  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ luasocket ];
  meta = {
    homepage = "https://gitlab.com/technomancy/jeejah";
    description = "An nREPL server";
    license.fullName = "MIT/X11";
  };
}
```

注意：luarocks 包源不在 nvfetcher 管理范围（需要 rockspec 元数据），直接用 fetchurl。

## 19. CMake C/C++ 项目（来源：pkgs/common/zpmod.nix）

```nix
{
  lib,
  stdenv,
  cmake,
  ncurses,
  source,
}:
stdenv.mkDerivation rec {
  inherit (source) pname src version;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses ];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DZPMOD_ENABLE_LTO=OFF"
  ];
  # 上游代码在新编译器下有可降级诊断时：
  NIX_CFLAGS_COMPILE = [
    "-Wno-error=incompatible-pointer-types"
    "-Wno-error=implicit-function-declaration"
  ];
  doCheck = false;
  meta = with lib; { /* ... */ };
}
```

## 20. Bun/Node 项目（来源：pkgs/common/mtranserver.nix）

模式：`bunDeps` 固定依赖（outputHash 固定）+ 上游 `--node` 产物 + 运行期依赖闭包 + `makeWrapper` 调 node。
结构较复杂，直接参考 `pkgs/common/mtranserver.nix` 全文，关键点：

- `bunDeps` 是一个独立 `stdenv.mkDerivation`，跑 `bun install --frozen-lockfile --ignore-scripts`，
  产出 node_modules 并用 `outputHash`/`outputHashMode = "recursive"` 固定。
- 主构建 `configurePhase` 把 bunDeps 的 node_modules 拷回并 `patchShebangs`。
- **不要用 `bun build --compile`**：单文件里只内联 JS，Node 原生插件（`.node`）运行时被解到临时目录，
  依赖的 `@rpath/*.dylib` 找不到 -> `ERR_DLOPEN_FAILED`（详见 troubleshooting §13）。
- 正确做法（对齐上游 Dockerfile）：`bun run build:node`（或 `bun build src/main.ts --target node --format esm
  --external <原生依赖>`）产出 `dist/*.js`，把 external 依赖按 `package.json` 的 `dependencies`
  递归拷进 `$out/lib/<name>/node_modules`，同目录写 `{"type":"module"}` 的 package.json，
  最后 `makeWrapper ${lib.getExe nodejs} $out/bin/<name> --add-flags "<entry>.js"`。
- 预编译二进制包往往带所有平台的原生库，安装时只留当前平台目录
  （onnxruntime-node 的 `bin/napi-v6/<platform>/<arch>`），其余删掉省闭包。
- 安装期冒烟检查：`node --input-type=module -e "await import('<原生依赖>')"` 与 `node <entry> --help`，
  能提前暴露原生库/依赖闭包缺失。
- 按系统分平台表：`{ aarch64-darwin = { bunDepsHash = ...; onnxRuntimePlatform = "darwin"; ... }; ... }.${stdenv.hostPlatform.system} or (throw ...)`。

## 21. AppleScript .app（来源：pkgs/darwin/emacsclient.nix）

用 `writeText` 写 AppleScript → `osacompile -o Xxx.app` → `plutil` 注入
Info.plist 字段（CFBundleIdentifier/URLTypes 等）→ 拷贝 .icns → `wrapProgramBinary`。
仅 macOS 专属小工具场景，参考 `pkgs/darwin/emacsclient.nix` 全文。
