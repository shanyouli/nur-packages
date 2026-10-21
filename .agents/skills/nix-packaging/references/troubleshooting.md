# 构建失败排查手册

按报错类型对号入座。

## 1. hash mismatch（最常见）

报错形如：
```
hash mismatch in fixed-output derivation '/nix/store/...':
  - specified: sha256-AAAAAAAA...
  - got:       sha256-XXXXXXXX...
```

处置：把 `got:` 的值替换表达式中的旧 hash。适用对象：
- Go 包 `vendorHash`
- Rust 包 `cargoHash`（本仓库用 cargoLock，一般不遇）
- `fetchurl` 的 `sha256`（sources.json 模式）

技巧：
- 新包 `vendorHash` 先写 `null`，构建报错会直接给出真实值（nixpkgs 新版行为）。
- CI 有自动替换逻辑（`nix/commands.nix` 的 `ci`/`devci` 命令），本地可 `nix run .#devci`。

## 2. cargoLock 属性缺失

报错：`attribute 'cargoLock' missing` 或 buildRustPackage 抱怨找不到 lock。

处置：`nvfetcher.toml` 对应条目加 `cargo_lock = ["Cargo.lock"]`（Tauri 用
`["./src-tauri/Cargo.lock"]`），重跑 `nix run .#nvfetcher`。
包表达式里键名必须与配置路径一致：`cargoLock = source.cargoLock."./src-tauri/Cargo.lock";`。

## 3. openssl-sys 构建失败 / vendoring 报错

报错：`openssl-sys` crate 编译失败或 `error: failed to run custom build command for openssl-sys`。

处置（fav/seam 模式）：
```nix
nativeBuildInputs = [ pkg-config ];   # 形参加 pkg-config
buildInputs = [ openssl ];
env = { OPENSSL_NO_VENDOR = true; };
```

## 4. bindgen / libclang 找不到

报错：`bindgen` 或 `Unable to find libclang`。

处置：`nativeBuildInputs = [ rustPlatform.bindgenHook ];`（ewt-rs 模式）。

## 5. Rust MSRV 过低（工具链太老）

报错：`rustc ... is not supported by the following packages`（要求更新 rustc）。

处置：改用 unstable 工具链（fav 模式）：形参加 `unstable`，
构建器换成 `unstable.rustPlatform.buildRustPackage`。

## 6. go.mod 要求更高 Go 版本

报错：`go.mod requires go >= 1.xx`。

处置二选一：
1. 形参加 `go_1_27`，用 `(buildGoModule.override { go = go_1_27; })`（tmux-fastcopy 模式）。
2. preBuild 修正 go.mod（deeplx 模式）：
   ```nix
   preBuild = ''
     sed -i 's/^go 1\(\.[0-9]\+\)\{1,2\}$/go ${go.version}/' go.mod
   '';
   ```

## 7. 测试失败

处置优先级：
1. 跳过个别测试（tmux-fastcopy 模式）：
   ```nix
   checkFlags = let skipped = [ "TestXxx" ]; in
     [ "--skip=^${builtins.concatStringsSep "$|^" skipped}$" ];
   ```
2. 整体关闭：`doCheck = false;`（本仓库常见，上游测试依赖网络/fixture 时）。
3. Fish 插件：`dontCheck = true;`。

## 8. macOS 框架/SDK 符号缺失

报错：`Undefined symbols`（_OBJC_CLASS_$_…、CoreFoundation 等）。

处置：`buildInputs = [ apple-sdk ];`（darwin 包）；跨平台包用
`++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk ]`。
注意用 `stdenv.hostPlatform.isDarwin` 判断（交叉编译安全）。

## 9. 平台不支持

- 构建器选错平台：确认包放对目录（darwin 包放 `pkgs/darwin/`）。
- 明确限定：`meta.platforms = platforms.darwin;`（或 `platforms.unix` / 列表）。
- 按系统分支（mtranserver 模式）：
  ```nix
  { aarch64-darwin = {...}; x86_64-linux = {...}; }.${stdenv.hostPlatform.system}
    or (throw "${pname}: unsupported system ${stdenv.hostPlatform.system}");
  ```

## 10. 上游 C 代码编译报错（新编译器默认 error 的警告）

GCC 14/15 起 `-Wimplicit-function-declaration`、`-Wincompatible-pointer-types` 默认 error。

处置（zpmod 模式）：
```nix
NIX_CFLAGS_COMPILE = [
  "-Wno-error=incompatible-pointer-types"
  "-Wno-error=implicit-function-declaration"
];
```

## 11. submodule 缺失

报错：找不到 vendor/ 子目录文件（上游用 git submodule）。

处置：nvfetcher.toml 加 `git.fetchSubmodules = true`（zpmod 模式）；
或手动把 nixpkgs 同名包源码解压进对应目录（zpmod 注释掉的 preConfigure 方案）。

## 12. 构建期需要写 HOME / 网络访问

- 测试要 HOME：`nativeBuildInputs = [ writableTmpDirAsHomeHook ];`（nixpkgs ripgrep 模式）。
- 构建期禁止网络是 sandbox 设计；需要拉依赖的（bun/go mod）必须用固定 hash 机制
  （vendorHash / bunDeps outputHash），不要试图放开网络。

## 13. 版本号异常

- `source.version` 是 40 位 hash：说明 nvfetcher 走了分支跟踪但没配 `date_format`，
  检查 `src.git` + `git.date_format`；`nurSources` 会兜底转成 `9.9.<date>`。
- 版本带 `v` 前缀：包内用 `lib.removePrefix "v" source.version` 或 nvfetcher
  `src.from_pattern`/`to_pattern` 处理。

## 14. 找不到同类问题的写法

去本地 nixpkgs checkout 对比同类包：

```bash
nix-instantiate --find-file nixpkgs   # 得到路径，如 /etc/nixpkgs
ls /etc/nixpkgs/pkgs/by-name/<首两字母>/<pkg>/package.nix
```

重点看：nativeBuildInputs/buildInputs 划分、patch 阶段处理、meta 声明。
注意 nixpkgs 用 `fetchFromGitHub` + `cargoHash`/`finalAttrs` 风格，
本仓库源走 nvfetcher，不要照抄源获取部分。
