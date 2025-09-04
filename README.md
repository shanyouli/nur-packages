# Shanyouli NUR PACKAGES

![Build and populate cache](https://github.com/shanyouli/nur-packages/workflows/Build%20and%20populate%20cache/badge.svg)

[![Cachix Cache](https://img.shields.io/badge/cachix-shanyouli-blue.svg)](https://shanyouli.cachix.org)

- LAST_MODIFY: 2025-09-04 07:29:32 UTC


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
- `readme`: Automatic generation of readme.md files using python


## packages

Currently only builds on **aarch64-darwin** and **x86_64-linux**, total: **65** packages.

### common

<details>
<summary>Default support for <b>aarch64-linux</b>,<b>aarch64-darwin</b>,<b>x86_64-linux</b> and <b>x86_64-darwin</b>. , Total: <b>32</b> packages </summary>

|name|broken system|version|description|
|:---|:---|:---|:---|
|[**alist**](https://github.com/alist-org/alist)||3.52.0|A file list/WebDAV program that supports multiple storages, powered by Gin and Solidjs. / 一个支持多存储的文件列表/WebDAV程序，使用 Gin 和 Solidjs|
|[**bash-env-json**](https://github.com/tesujimath/bash-env-json)||0.7.0| export of Bash environment as JSON|
|[**bbdown**](https://github.com/nilaoda/BBDown)||9.9-unstable-2025-08-03|Bilibili Downloader. 一款命令行式哔哩哔哩下载器.|
|[**clash2singbox**](https://github.com/xmdhs/clash2singbox)||0.1.4|将 clash.meta 格式的配置文件或链接转换为 sing-box 格式|
|[**deeplx**](https://github.com/OwO-Network/DeepLX)||1.0.8|DeepL Free API (No TOKEN required|
|[**emacs**](https://www.gnu.org/software/emacs/)||30.2|Extensible, customizable GNU text editor|
|[**emacs**](https://www.gnu.org/software/emacs/)||20250829.0|Extensible, customizable GNU text editor|
|[**emacs**](https://www.gnu.org/software/emacs/)||30.2|Extensible, customizable GNU text editor|
|[**fav**](https://github.com/kingwingfly/fav)||1.1.1|Back up your favorite bilibili resources with CLI|
|[**fisher**](https://github.com/jorgebucaran/fisher)||4.4.5|A plugin manager for Fish|
|[**go-musicfox**](https://github.com/go-musicfox/go-musicfox)||4.7.1|go-musicfox是用Go写的又一款网易云音乐命令行客户端|
|[**antifennel**](https://git.sr.ht/~technomancy/antifennel)||2025-06-27|Turn Lua code into Fennel code|
|[**jeejah**](https://gitlab.com/technomancy/jeejah)||unstable-2023-09-28|An nREPL server|
|[**manix**](https://github.com/kaii-zen/manix/tree/master)||2021-07-28|A fast CLI documentation searcher for Nix|
|[**musicn**](https://github.com/zonemeen/musicn)||1.5.3-beta.0|🎵 一个可播放及下载音乐的 Node.js 命令行工具 |
|[**nix-index**](None)|||None|
|[**pragmasevka**](https://github.com/shanyouli/iosevka)||33.2.8|我的自定义 iosvake|
|[**pragmasevka-nerd**](https://github.com/shanyouli/iosevka)||33.2.8|我的自定义 iosvake|
|[**pragmasevka-sans**](https://github.com/shanyouli/iosevka)||33.2.8|我的自定义 iosvake|
|[**pragmasevka-sc**](https://github.com/shanyouli/iosevka)||33.2.8|我的自定义 iosvake, 使用 LXGW-wenKai 作为中文字体|
|[**pragmasevka-sc-nf**](https://github.com/shanyouli/iosevka)||33.2.8|我的自定义 iosvake, 使用 LXGW-wenKai 作为中文字体|
|[**pragmasevka-serif**](https://github.com/shanyouli/iosevka)||33.2.8|我的自定义 iosvake|
|[**qbittorrent-enhanced**](https://www.qbittorrent.org)||release-5.1.2.10|Featureful free software BitTorrent client|
|[**qbittorrent-enhanced-nox**](https://www.qbittorrent.org)||release-5.1.2.10|Featureful free software BitTorrent client|
|[**rime-ice**](https://dvel.me/posts/rime-ice/)||unstable-2025-08-29|Rime 配置:雾凇拼音|
|[**moqi**](https://github.com/amzxyz/rime_wanxiang_pro)||v11.4.0|Rime 配置:万象输入法|
|[**sarasa-term**](https://github.com/laishulu/Sarasa-Term-SC-Nerd)||2.3.1|中英文宽度完美 2:1 字体|
|[**seam**](https://github.com/Borber/seam)||_cli.0.1.39|获取多直播平台的直播源|
|[**singboxp**](https://sing-box.sagernet.org)||2025-08-04|The universal proxy platform|
|[**tmux-fastcopy**](https://github.com/abhinav/tmux-fastcopy/tree/main)||0.14.1|easymotion-style text copying for tmux.|
|[**userChromeJS**](https://github.com/benzBrake/userChrome.js-Loader)||2025-09-02|Firefox scripts |
|[**zpmod**](https://github.com/z-shell/zpmod)||1.1.0|Zsh module transparently and automatically compiles sourced scripts|
</details>

### darwin

<details>
<summary>Only support for <b>aarch64-darwin</b>, <b>x86_64-darwin</b>, Most <b>GUI packages</b> only support <b>aarch64-darwin</b>. , Total: <b>11</b> packages </summary>

|name|broken system|version|description|
|:---|:---|:---|:---|
|[**aerospace**](https://github.com/nikitabobko/AeroSpace)||0.19.2-Beta|AeroSpace is an i3-like tiling window manager for macOS|
|[**borders**](https://github.com/FelixKratz/JankyBorders)||1.7.0|window border system for macOS|
|[**dutis**](https://github.com/tsonglew/dutis)||unstable-2025-08-24|A command-line tool to select default applications, based on duti|
|[**EmacsClient**](None)||29.2|None|
|[**firefox-esr**](http://www.mozilla.com/en-US/firefox/)||128.14.0esr|Mozilla Firefox, free web browser (binary package)|
|[**lporg**](https://github.com/blacktop/lporg)||20.4.32|Organize Your macOS Launchpad Apps|
|[**mkalias**](https://github.com/reckenrode/mkalias)||0.3.2|Simple command-line tool to create Finder aliases|
|[**nowplaying-cli**](https://github.com/kirtan-shah/nowplaying-cli)||1.2.1|macOS command-line utility for retrieving currently playing media|
|[**pngpaste**](https://github.com/jcsalterego/pngpaste)||0.2.3|Paste PNG into files, much like pbpaste does for text. |
|[**switchaudio-osx**](https://github.com/deweller/switchaudio-osx)||1.2.2|Change the audio source for Mac OS X from the command line|
|[**yabai-zsh-completions**](https://github.com/Amar1729/yabai-zsh-completions)||2023-11-13|zsh completions for yabai, the tiling window manager|
</details>

### firefox-addons

<details>
<summary><b>firefox extension</b>, default support for all systems that support firefox. , Total: <b>18</b> packages </summary>

|name|broken system|version|description|
|:---|:---|:---|:---|
|[**auto-tab-discard**](https://webextension.org/listing/tab-discard.html)||0.6.7|Dark Reader Chrome and Firefox extension|
|[**browserpass-ce**](https://github.com/browserpass/browserpass-extension)||3.11.0|Browserpass is a browser extension for Firefox and Chrome to retrieve login details from zx2c4's pass (<a href="https://prod.outgoing.prod.webservices.mozgcp.net/v1/fcd8dcb23434c51a78197a1c25d3e2277aa1bc764c827b4b4726ec5a5657eb64/http%3A//passwordstore.org" rel="nofollow">passwordstore.org</a>) straight from your browser. Tags: passwordstore, password store, password manager, passwordmanager, gpg|
|[**chrome-mask**](https://github.com/denschub/chrome-mask)||6.0.0|Makes Firefox wear a mask to look like Chrome.|
|[**darkreader**](https://darkreader.org/)||4.9.110|Dark Reader Chrome and Firefox extension|
|[**download-with-aria2**](https://github.com/jc3213/download_with_aria2)||4.17.0.3548|Browser extension for aria2c json-rpc |
|[**easy-image-blocker**](https://addons.mozilla.org/en-US/firefox/addon/easy-image-blocker/)||3.1.5|Easy Image Blocker is the Add-on to control the loading of the image.|
|[**immersive-translate**](https://immersivetranslate.com/)||1.20.8|Immersive Dual Web Page Translation Extension |
|[**kiss-translator**](https://github.com/fishjar/kiss-translator)||1.9.2|Simple, open source bilingual translation extension & Greasemonkey script|
|[**noscript**](https://noscript.net/)||13.0.9|NoScript Security Suite|
|[**privacy-pass**](https://github.com/cloudflare/pp-browser-extension)||4.0.2|Client for Privacy Pass protocol providing unlinkable cryptographic tokens|
|[**raindropio**](https://app.raindrop.io/)||6.6.90|All-in-one bookmark manager|
|[**sidebery**](https://github.com/mbnuqw/sidebery)||5.3.3|Firefox extension for managing tabs and bookmarks in sidebar|
|[**styl-us**](https://add0n.com/stylus.html)||2.3.16|Stylus - Userstyles Manager|
|[**surfingkeys_ff**](https://github.com/brookhong/Surfingkeys)||1.17.5|Map your keys for web surfing, expand your browser with javascript and keyboard. |
|[**ublock-origin**](https://github.com/gorhill/uBlock)||1.65.0|uBlock Origin - An efficient blocker for Chromium and Firefox. Fast and lean. |
|[**user-agent-string-switcher**](https://add0n.com/useragent-switcher.html)||0.6.5.1|User-Agent Switcher and Manager|
|[**violentmonkey**](https://violentmonkey.github.io)||2.31.0|An open source userscript manager.|
|[**zeroomega**](https://github.com/zero-peak/ZeroOmega)||3.4.1| Manage and switch between multiple proxies quickly & easily.|
</details>

### python3-apps

<details>
<summary>Installing <b>python programs</b> with nix. , Total: <b>4</b> packages </summary>

|name|broken system|version|description|
|:---|:---|:---|:---|
|[**alive-progress**](None)||3.3.0|None|
|[**musicdl**](https://github.com/CharlesPikachu/musicdl)||2023-02-22|A lightweight music downloader written in pure python.|
|[**sd**](None)||2025-05-29|My system command line|
|[**websocket-bridge-python**](None)||0.0.2|None|
</details>

