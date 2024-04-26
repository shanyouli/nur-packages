# Shanyouli NUR PACKAGES

![Build and populate cache](https://github.com/shanyouli/nur-packages/workflows/Build%20and%20populate%20cache/badge.svg)

[![Cachix Cache](https://img.shields.io/badge/cachix-shanyouli-blue.svg)](https://shanyouli.cachix.org)

- LAST_MODIFY: 2024-04-26 20:43:12 CST


## How to use

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nur-shanyouli = {
      url = "github:shanyouli/nur-packages";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ ... }: {
          nixpkgs.overlays = [inputs.nur-shanyouli.overlay];
          # Binary cache (optional)
          nix.settings.substituters = [ "https://shanyouli.cachix.org" ];
          nix.settings.trusted-public-keys = [ "shanyouli.cachix.org-1:19ndCE7zQfn5vIVLbBZk6XG0D7Ago7oRNNgIRV/Oabw=" ];
        })
      ];
    };
  };
}
```


## Binary Cache

```nix
{
  nix.settings.substituters = [ "https://shanyouli.cachix.org" ];
  nix.settings.trusted-public-keys = [ "shanyouli.cachix.org-1:19ndCE7zQfn5vIVLbBZk6XG0D7Ago7oRNNgIRV/Oabw=" ];
}
```


## apps

- `ci`: Perform the verification process for github's workflows
- `devci`: Test commands used when developing or writing a package
- `nvfetcher`: Use the nvfetcher command to update the original code of the package
- `bbdownDeps`: Updating bbdown's dependencies using bbdown's own update scripts
- `updatePy`: Updating the source code of certain packages using python scripts
- `upFlake`: Automatic `inputs` source


## packages

Currently only builds on aarch64-darwin and x86_64-linux

### common

Default support for *aarch64-linux,aarch64-darwin,x86_64-linux and x86_64-darwin*

|name|broken system| description|
|:---|:---|:---|
|`alist`||A file list/WebDAV program that supports multiple storages, powered by Gin and Solidjs. / 一个支持多存储的文件列表/WebDAV程序，使用 Gin 和 Solidjs|
|`bbdown`||Bilibili Downloader. 一款命令行式哔哩哔哩下载器.|
|`clash2singbox`||将 clash.meta 格式的配置文件或链接转换为 sing-box 格式|
|`deeplx`||DeepL Free API (No TOKEN required|
|`emacs`||The extensible, customizable GNU text editor|
|`emacsGit`||The extensible, customizable GNU text editor|
|`fav`||Back up your favorite bilibili resources with CLI|
|`firefox-utils`||Firefox scripts |
|`go-musicfox`||go-musicfox是用Go写的又一款网易云音乐命令行客户端|
|`lazyvim-star`||LazyVim is a Neovim setup powered by 💤 lazy.nvim to make it easy to customize and extend your config.|
|`maple-mono`||Open source monospace/Nerd Font |
|`maple-sc-nf`||Open source monospace/Nerd Font |
|`mihomo`||A simple Python Pydantic model for Honkai: Star Rail parsed data from the Mihomo API|
|`musicn`||🎵 一个可播放及下载音乐的 Node.js 命令行工具 |
|`qbittorrent-enhanced`||Featureful free software BitTorrent client|
|`qbittorrent-enhanced-nox`||Featureful free software BitTorrent client|
|`seam`||获取多直播平台的直播源|
|`xbydriver`||小白羊网盘 - Powered by 阿里云盘。|
|`zpmod`||Zsh module transparently and automatically compiles sourced scripts|

### darwin

Only support for *aarch64-darwin*, *x86_64-darwin*, Most gui packages only support aarch64-darwin

|name|broken system| description|
|:---|:---|:---|
|`alexandria`||A minimalistic cross-platform eBook reader built with Tauri, Epub.js, and Typescript|
|`calibre`||ebook management|
|`chatgpt`|"x86_64-darwin"|ChatGPT Desktop Application (Mac, Windows and Linux) |
|`chrome`||Google Chrome stable|
|`chromium`||Open source version of Google-chrome|
|`clash-nyanpasu`||Clash Nyanpasu! (∠・ω< )⌒☆​|
|`clash-verge`||A Clash GUI based on tauri. Supports Windows, macOS and Linux. |
|`downkyi`|| 哔哩下载姬(跨平台版)downkyi，哔哩哔哩网站视频下载工具，支持批量下载，支持8K、HDR、杜比视界，提供工具箱（音视频提取、去水印等）|
|`dutis`||A command-line tool to select default applications, based on duti|
|`emacsclient`||None|
|`firefox`||Mozilla Firefox, free web browser (binary package)|
|`iina`||IINA mplayer|
|`iinaplus`||Extra danmaku support for iina (iina 弹幕支持)|
|`localsend`||Share files to nearby devices. Free, open source, cross-platform|
|`lporg`||Organize Your macOS Launchpad Apps|
|`lyricx`||🎶 Ultimate lyrics app for macOS. |
|`neovide`||No Nonsense Neovim Client in Rust|
|`next-chat`||ChatGpt Next Web|
|`pngpaste`||Paste PNG into files, much like pbpaste does for text. |
|`qutebrowser`||Keyboard-driven, vim-like browser based on PyQt5|
|`rpcs3`||rpcs3|
|`ryujinx`||A simple, experimental Nintendo Switch emulator|
|`ryusak`||Color finder for switch emulator|
|`simple-live`||Simple Live 简简单单的看直播 |
|`spotube`||Open source Spotify client|
|`switchaudio-osx`||Change the audio source for Mac OS X from the command line|
|`tmexclude`||Exclude undesired files (node_modules, target, etc) from your TimeMachine backup. |
|`upic`||upic 图床管理|
|`vivaldi`||Vivaldi Browser|
|`wiliwili`||第三方B站客户端|
|`yabai`||A tiling window manager for macOS based on binary space partitioning|
|`yabai-zsh-completions`||zsh completions for yabai, the tiling window manager|
|`zy-player`||跨平台视频资源播放器, 简洁免费无广告.|

### firefox-addons

*firefox extension*, default support for all systems that support firefox

|name| description|
|:---|:---|
|`auto-tab-discard`|Dark Reader Chrome and Firefox extension|
|`browserpass-ce`|Browserpass is a browser extension for Firefox and Chrome to retrieve login details from zx2c4's pass (<a href="https://prod.outgoing.prod.webservices.mozgcp.net/v1/fcd8dcb23434c51a78197a1c25d3e2277aa1bc764c827b4b4726ec5a5657eb64/http%3A//passwordstore.org" rel="nofollow">passwordstore.org</a>) straight from your browser. Tags: passwordstore, password store, password manager, passwordmanager, gpg|
|`darkreader`|Dark Reader Chrome and Firefox extension|
|`download-with-aria2`|Browser extension for aria2c json-rpc |
|`noscript`|NoScript Security Suite|
|`privacy-pass`|Client for Privacy Pass protocol providing unlinkable cryptographic tokens|
|`sidebery`|Firefox extension for managing tabs and bookmarks in sidebar|
|`styl-us`|Stylus - Userstyles Manager|
|`surfingkeys_ff`|Map your keys for web surfing, expand your browser with javascript and keyboard. |
|`switchyomega`|Manage and switch between multiple proxies quickly & easily.|
|`ublock-origin`|uBlock Origin - An efficient blocker for Chromium and Firefox. Fast and lean. |
|`user-agent-string-switcher`|User-Agent Switcher and Manager|
|`violentmonkey`|An open source userscript manager.|

### python3-apps

Installing python programs with nix

|name| description|
|:---|:---|
|`about-time`|None|
|`alive-progress`|None|
|`musicdl`|A lightweight music downloader written in pure python.|
|`sd`|My system command line|
|`websocket-bridge-python`|None|
|`yutto`|Ice_cube: 一个可爱且任性的 B 站视频下载器（bilili V2|

