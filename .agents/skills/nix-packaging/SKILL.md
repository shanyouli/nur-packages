---
name: nix-packaging
description: >
  在本 NUR 仓库中为软件编写 nix 打包脚本：按包类型（Rust/Go/Python/字体/macOS App/
  Firefox 扩展/Emacs/Fish/Lua/CMake/Bun/数据文件）选择构建器模板，配置 nvfetcher
  源条目，生成 pkgs/<category>/<name>.nix，处理版本号、hash、平台条件依赖，
  并覆盖更新已有包与构建失败排查。当用户要求「打包 xxx」「新增一个包」「写个 nix
  表达式/构建脚本」「更新包版本」「nix build 失败排查」时触发。
  不适用于：向 nixpkgs 上游贡献、非本仓库的打包任务、NixOS 模块/配置编写。
---

# Nix Packaging（本 NUR 仓库打包指南）

你是本仓库的打包工程师。目标：为任意常用形态的软件生成可直接构建的 nix 表达式，
或指导用户完成打包/更新/排错。

## 1. 仓库装配机制（必须先理解）

本仓库**不直接用 fetchFromGitHub**，源统一由 nvfetcher 管理：

```
nvfetcher.toml ──(nix run .#nvfetcher)──> _sources/generated.nix
                                              │
nix/pkgs.nix 的 callPkg' 按包文件名取同名源，注入参数：
  source  ← 单个包的源（pname/version/src/cargoLock/date…）
  sources ← 整个源属性集（仅需要跨包引用时声明）
  pkgs    ← final 包集；unstable ← nixpkgs-unstable 裸包集（新工具链用）
```

- 包文件是一个**函数**，形参即依赖：`{ lib, rustPlatform, source, ... }: ...`。
  只声明实际用到的形参，装配层按 `functionArgs` 自动求交集注入。
- 包目录下若有 `sources.json`（配合 `update.py`），则优先于 nvfetcher 源
  （见 `pkgs/common/rime-wanxiang/`、`pkgs/darwin/firefox/`）。仅特殊场景使用。
- `source` 经 `nix/lib/utils.nix` 的 `nurSources` 处理：`v` 前缀已去除逻辑由
  包内自行处理；40 位 commit hash 版本会转为 `9.9.<date>`。

### 分类目录与 flake 输出名

| 目录 | 典型构建器 / 注入 | flake 输出名 |
|------|------------------|--------------|
| `pkgs/common/` | 任意（跨平台） | `<name>` |
| `pkgs/darwin/` | stdenv + apple-sdk / mkDarwinApp | `darwin-apps-<name>` |
| `pkgs/python/` | buildPythonPackage/Application（注入 `python3Packages`） | `python-apps-<name>` |
| `pkgs/lua/` | buildLuarocksPackage（注入 `lua`、`luaPackages`） | `lua-apps-<name>` |
| `pkgs/emacs/` | melpaBuild（注入 `emacs`） | `emacs-packages-<name>` |
| `pkgs/fish/` | buildFishPlugin | `fish-<name>` |
| `pkgs/firefox-addons/` | mkFirefoxAddon | `firefox-addons-<name>` |

## 2. 输入要求与澄清策略

打包前必须确认（缺一项就先问用户，不要猜）：

1. **上游地址**：GitHub/GitLab repo、release 资产 URL 或 pypi 名。
2. **包类型**：若用户没说，读上游仓库判断（看 Cargo.lock / go.mod / pyproject.toml /
   setup.py / .xpi / .dmg / .ttf 等）。判断不了再问。
3. **跟踪策略**：跟最新 tag（`src.github`）还是跟分支（`src.git` + 日期版本）。
   上游不发 tag → 用分支跟踪。

## 3. 标准流程：新增一个包

1. **定位**：确定包类型与分类目录（见 §4 决策树）。
2. **登记源**：在 `nvfetcher.toml` 添加条目（模式见 `references/nvfetcher.md`）。
   Rust 项目必须加 `cargo_lock = ["Cargo.lock"]`（Tauri 用 `["./src-tauri/Cargo.lock"]`）。
3. **拉取源**：本地或 CI 二选一，**先问用户**：
   - 本地：`nix run .#nvfetcher` 更新 `_sources/generated.nix`；
   - CI 代跑：由你编辑 `tests/dev.yaml` 置 `upNvfetcher: true`（见步骤 5 的格式）。
4. **写表达式**：在 `pkgs/<category>/<name>.nix` 创建文件，从
   `references/templates.md` 选对应模板改写。
5. **验证**：本地或 CI 二选一，**先问用户，不得默认本地构建**：
   - 本地：`nix build .#<输出名>`；hash 类错误按提示替换
     （vendorHash 可先写 `null` 触发真实 hash 输出）。
   - CI：**由你编辑 `tests/dev.yaml`**（纯本地文件编辑，直接完成，无需授权）：
     ```yaml
     dev: true            # 只构建 apps 列出的包；false 则 CI 构建全部包
     upNvfetcher: false   # 步骤 3 选 CI 代跑时置 true，CI 先执行 nvfetcher
     upPy: false          # 需刷新 sources.json 类源时置 true，CI 先执行 updatePy
     apps:
       - python-apps-sd   # 本次要验证的 flake 输出名；不在 packages 集内的名字会被静默过滤
     ```
     `apps` 直接写目标输出名（现有占位说明项可移除，CI 结束后 workflow 会
     自动重置 dev.yaml）。随后推送到 `dev` 分支触发
     `.github/workflows/devpkgs.yml`：ubuntu + macos 双平台矩阵构建，
     自动替换 hash 并回推 `temp-testdev-*` 分支。
   排查见 `references/troubleshooting.md`。
6. **收尾**：`nix run .#readme` 重新生成 README 包列表（本地脚本，无网络）。

## 4. 类型决策树

```
上游是什么？
├─ Cargo.lock 存在
│   ├─ 普通 Rust 项目 ──────── rustPlatform.buildRustPackage + cargoLock
│   ├─ src-tauri/ 目录 ────── 同上 + cargoRoot/buildAndTestSubdir = "src-tauri"
│   └─ workspace 多 bin ───── cargoBuildFlags = [ "--package" "<bin>" ]
├─ go.mod 存在 ─────────────── buildGoModule + vendorHash（ldflags -s -w）
├─ pyproject.toml / setup.py
│   ├─ CLI 应用 ───────────── buildPythonApplication + pyproject = true
│   └─ importable 库 ───────── buildPythonPackage（python3Packages 注入）
├─ .ttf/.otf/.ttc 压缩包 ───── stdenvNoCC.mkDerivation + p7zip/unzip
├─ 纯数据/配置/脚本文件 ─────── runCommand / stdenvNoCC（无编译）
├─ macOS 预编译 CLI ────────── stdenv.mkDerivation + apple-sdk + installPhase
├─ .app（dmg/zip 内）───────── mkDarwinApp（nix/plib/build-support/）
├─ .xpi Firefox 扩展 ───────── mkFirefoxAddon + addonId
├─ Emacs Lisp ──────────────── melpaBuild（ename + files）
├─ Fish 插件 ───────────────── buildFishPlugin
├─ Lua rockspec ────────────── buildLuarocksPackage + knownRockspec
├─ CMake/Makefile C/C++ ────── stdenv.mkDerivation + cmake/nativeBuildInputs
└─ Bun/Node 项目 ───────────── bunDeps 固定依赖 + bun build --compile
```

每个类型的完整模板在 `references/templates.md`，先读它再写。

## 5. 核心惯例（所有模板共用）

**版本号**（nvfetcher 分支跟踪产生 `date`，tag 跟踪产生 `version`）：

```nix
version =
  if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
```

tag 跟踪且确定无 `date` 时可直接 `inherit (source) pname version src;`。

**meta 必填项**：`description`、`homepage`、`license`（查 `lib.licenses`）、
`mainProgram`（有可执行文件时）。平台限定：darwin 包写 `platforms = platforms.darwin;`。

**平台条件依赖**（跨平台包引用 macOS SDK）：

```nix
buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk ];
```

**shell 补全**：用 `installShellFiles`；交叉编译时用 emulator 运行目标二进制生成
（见 `pkgs/common/singboxp.nix`）。

**nixpkgs 参考**：更多构建范例在本地 checkout
`$(nix-instantiate --find-file nixpkgs)/pkgs/by-name/<首两字母>/<pkg>/package.nix`
（如 ripgrep、bat、keep-sorted、pdfannots）。参考其依赖声明、meta、
`finalAttrs` 风格与 `versionCheckHook`；但**源获取方式遵循本仓库 nvfetcher 惯例**，
不照抄 fetchFromGitHub。

## 6. 更新已有包

1. 刷新源：本地 `nix run .#nvfetcher`，或 CI 代跑（编辑 dev.yaml 置 `upNvfetcher: true`）。
2. 验证：本地 `nix build .#<输出名>`，或 CI（编辑 dev.yaml：`dev: true` +
   `apps` 写输出名，推 dev 分支；格式见 §3 步骤 5）。
   vendorHash/cargoHash 变化按报错替换；CI 的 `devci`/`ci` 命令会自动替换 hash。
3. 带 `sources.json` + `update.py` 的包（rime-wanxiang、firefox-addons、darwin/firefox）
   用 `nix run .#updatePy` 更新，或 CI 代跑（dev.yaml 置 `upPy: true`）。
4. CI 自动 hash 替换逻辑在 `nix/commands.nix` 的 `ci`/`devci` 命令，本地复现：`nix run .#devci`。

## 7. 失败处理

构建报错先查 `references/troubleshooting.md`（hash mismatch、cargoLock 缺失、
openssl vendored、bindgen、MSRV、go.mod 版本、测试失败、平台限制等均有处置方案）。
该文件没有的场景：读 `nixpkgs` 中同类包的写法对比差异。

## 8. 质量自检清单

- [ ] nvfetcher.toml 条目与包文件名一致（`source` 按文件名匹配）
- [ ] Rust 包有 `cargoLock`；Go 包 `vendorHash` 已填真实值
- [ ] version 表达式与跟踪策略匹配（date vs tag）
- [ ] meta 四项齐全；darwin 包有 platforms 限定
- [ ] 未引入本仓库模板之外的 fetchFromGitHub/fetchurl（sources.json 模式除外）
- [ ] 拉取源与验证方式已经用户确认（本地 or CI），未擅自本地执行构建
- [ ] CI 验证时 `tests/dev.yaml` 已由你配置好（`dev: true`，`apps` 为准确 flake 输出名）

## 参考资料

- `references/templates.md` — 12 类包的完整可改写模板（含来源文件标注）
- `references/nvfetcher.md` — nvfetcher.toml 全部配置模式与 sources.json 例外流程
- `references/troubleshooting.md` — 构建失败排查手册
- 仓库内活例子：`nix/pkgs.nix`（装配）、`nix/lib/utils.nix`（nurSources）、
  `nix/plib/build-support/`（mkDarwinApp / mkFirefoxAddon）
