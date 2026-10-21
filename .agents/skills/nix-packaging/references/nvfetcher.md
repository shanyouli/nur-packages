# nvfetcher 源配置模式

源统一在 `nvfetcher.toml` 登记，运行 `nix run .#nvfetcher` 后生成 `_sources/generated.nix`。

TOML 中**不要写中文注释**（上游 nvfetcher 解析会报错，见文件头部说明）。

## 条目结构

每个包一个 `[name]` 节，`name` 必须与 `pkgs/<category>/<name>.nix` 文件名一致
（`source` 参数按文件名匹配）。两大部分：

- `src.*`：**版本从哪来**（跟踪策略）
- `fetch.*`：**源码怎么抓**

## src 模式（版本跟踪）

| 配置 | 含义 | 例子 |
|------|------|------|
| `src.github = "owner/repo"` | 跟踪 GitHub 最新 release tag | `[tmux-fastcopy]` |
| `src.github_tag = "owner/repo"` | 跟踪最新 git tag（含非 release） | `[mkalias]`、`[pngpaste]` |
| `src.git = "https://...git"` + `git.date_format = "%Y%m%d"` | 跟踪分支 HEAD，版本=日期 | `[manix]`、`[rime-ice]` |
| `src.pypi = "name"` | 跟踪 pypi 版本 | `[alive-progress]` |
| `src.webpage = "url"` + `src.regex = "..."` | 从网页正则抓版本 | `[vivaldi]`（注释示例） |
| `src.manual = "v30"` | 固定版本 | `["emacs30.ns-mac-input-source"]` |
| `src.from_pattern` / `src.to_pattern` | 版本号变换（配合 $ver） | `[maple-mono]` |

## fetch 模式（源抓取）

| 配置 | 含义 | 例子 |
|------|------|------|
| `fetch.github = "owner/repo"` | 抓 GitHub release tag tarball | 绝大多数包 |
| `fetch.url = ".../$ver/..."` | 抓 release 资产（$ver 替换） | 字体 zip、.xpi、patch |
| `fetch.pypi = "name"` | 抓 pypi sdist | `[alive-progress]` |
| `fetch.git = "url"` | 抓 git HEAD | `[antifennel]` |

## 常用附加键

| 键 | 含义 | 例子 |
|----|------|------|
| `cargo_lock = ["Cargo.lock"]` | 生成 `source.cargoLock."Cargo.lock"`（Rust 包必加） | `[manix]` |
| `cargo_lock = ["./src-tauri/Cargo.lock"]` | Tauri 子目录 lock | `[cc-switch]` |
| `git.fetchSubmodules = true/false` | 是否抓 submodule | `[zpmod]` true |
| `src.from_pattern = "v(.*)"` + `src.to_pattern = "\\1"` | 把 v1.2.3 变 1.2.3 供 $ver 用 | `[pragmasevka]` |

## 典型组合速查

**Rust CLI 跟 tag：**
```toml
[ewt-rs]
src.github = "Master-Hash/ewt-rs"
fetch.github = "Master-Hash/ewt-rs"
cargo_lock = ["Cargo.lock"]
```

**Rust CLI 跟分支（日期版本）：**
```toml
[manix]
src.git = "https://github.com/kaii-zen/manix"
git.date_format = "%Y%m%d"
fetch.github = "kaii-zen/manix"
cargo_lock = ["Cargo.lock"]
```

**Go CLI 跟分支：**
```toml
[singboxp]
fetch.github = "PuerNya/sing-box"
src.git = "https://github.com/PuerNya/sing-box"
git.date_format = "%Y%m%d"
```

**Release 资产（字体/二进制）：**
```toml
[maple-mono]
src.github = "shanyouli/maple-mono-action"
src.from_pattern = "v(.*)"
src.to_pattern = "\\1"
fetch.url = "https://github.com/shanyouli/maple-mono-action/releases/download/v$ver/MapleMonoNR-TTF.zip"
```

**Firefox 扩展 .xpi：**
```toml
[darkreader]
src.github = "darkreader/darkreader"
src.from_pattern = "v(.*)"
src.to_pattern = "\\1"
fetch.url = "https://github.com/darkreader/darkreader/releases/download/v$ver/darkreader-firefox.xpi"
```

**Python pypi：**
```toml
[alive-progress]
fetch.pypi = "alive-progress"
src.pypi = "alive-progress"
```

**单文件资产（patch/icns）：**
```toml
[emacsclient]
src.git = "https://github.com/nashamri/spacemacs-logo"
fetch.url = "https://github.com/nashamri/spacemacs-logo/raw/$ver/spacemacs.icns"
```

## 运行与产出

```bash
nix run .#nvfetcher   # 读 nvfetcher.toml，写 _sources/generated.nix + 锁文件
```

也可交给 CI 代跑：`tests/dev.yaml` 置 `upNvfetcher: true` 后推送到 `dev` 分支，
devpkgs.yml 会用 `GITHUB_TOKEN` 作为 key 执行 nvfetcher 并回推变更。

- 产出经 `nix/lib/utils.nix` 的 `nurSources` 包装后注入包的 `source` 形参。
- `source` 常见字段：`pname`、`version`、`date`（分支跟踪时）、`src`、`cargoLock`。
- 若 `~/.config/nvfetcher.toml` 或 `./secrets.toml` 存在会自动作为 key 文件
  （见 `nix/commands.nix` 的 nvfetcher 命令）。

## 例外：sources.json + update.py 模式

nvfetcher 抓不了的源（如需要 API key、多变体选择），在包目录放 `sources.json`：

```
pkgs/common/rime-wanxiang/
├── default.nix     # builtins.fromJSON (builtins.readFile ./sources.json)
├── sources.json    # { "base": { version, url, sha256 }, "fuzu": {...} }
└── update.py       # nix run .#updatePy 批量刷新
```

`nix/pkgs.nix` 的 `sourceFn` 优先读包目录下的 `sources.json`（按包文件名取键），
没有才回落 nvfetcher 源。适用：`pkgs/common/rime-wanxiang/`、`pkgs/darwin/firefox/`、
`pkgs/firefox-addons/`（该目录的 sources.json 由 update.py 维护）。
