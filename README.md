# Shanyouli NUR PACKAGES

![Build and populate cache](https://github.com/shanyouli/nur-packages/workflows/Build%20and%20populate%20cache/badge.svg)

[![Cachix Cache](https://img.shields.io/badge/cachix-shanyouli-blue.svg)](https://shanyouli.cachix.org)

- LAST_MODIFY: 2024-10-23 08:09:24 UTC


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

Currently only builds on **aarch64-darwin** and **x86_64-linux**, total: **56** packages.

### common

<details>
<summary>Default support for <b>aarch64-linux</b>,<b>aarch64-darwin</b>,<b>x86_64-linux</b> and <b>x86_64-darwin</b>. , Total: <b>23</b> packages </summary>

|name|broken system|version|description|
|:---|:---|:---|:---|
|[**alist**](https://github.com/alist-org/alist)||3.38.0|A file list/WebDAV program that supports multiple storages, powered by Gin and Solidjs. / 一个支持多存储的文件列表/WebDAV程序，使用 Gin 和 Solidjs|
|[**bash-env-json**](https://github.com/tesujimath/bash-env-json)||0.7.0| export of Bash environment as JSON|
|[**bbdown**](https://github.com/nilaoda/BBDown)||2024-09-01|Bilibili Downloader. 一款命令行式哔哩哔哩下载器.|
|[**clash2singbox**](https://github.com/xmdhs/clash2singbox)||0.1.4|将 clash.meta 格式的配置文件或链接转换为 sing-box 格式|
|[**deeplx**](https://github.com/OwO-Network/DeepLX)||0.9.8|DeepL Free API (No TOKEN required|
|[**emacs**](https://www.gnu.org/software/emacs/)||30.0.91|Extensible, customizable GNU text editor|
|[**emacs**](https://www.gnu.org/software/emacs/)||20241018.0|Extensible, customizable GNU text editor|
|[**fav**](https://github.com/kingwingfly/fav)||0.2.33|Back up your favorite bilibili resources with CLI|
|[**fisher**](https://github.com/jorgebucaran/fisher)||4.4.5|A plugin manager for Fish|
|[**go-musicfox**](https://github.com/go-musicfox/go-musicfox)||4.5.5|go-musicfox是用Go写的又一款网易云音乐命令行客户端|
|[**manix**](https://github.com/kaii-zen/manix/tree/master)||2021-07-28|A fast CLI documentation searcher for Nix|
|[**maple-mono**](https://github.com/subframe7536/Maple-font)||6.4|Open source monospace/Nerd Font |
|[**maple-sc-nf**](https://github.com/subframe7536/Maple-font)||6.4|Open source monospace/Nerd Font |
|[**mpvc**](https://gmt4.github.io/mpvc/)||1.5-vinyl|A mpc-like control interface for mpv|
|[**musicn**](https://github.com/zonemeen/musicn)||1.5.0|🎵 一个可播放及下载音乐的 Node.js 命令行工具 |
|[**nh_darwin**](https://github.com/viperML/nh)||2024-10-10|Yet another nix cli helper|
|[**nix-index**](None)|||None|
|[**qbittorrent-enhanced**](https://www.qbittorrent.org)||release-4.6.7.10|Featureful free software BitTorrent client|
|[**qbittorrent-enhanced-nox**](https://www.qbittorrent.org)||release-4.6.7.10|Featureful free software BitTorrent client|
|[**seam**](https://github.com/Borber/seam)||_cli.0.1.39|获取多直播平台的直播源|
|[**tmux-fastcopy**](https://github.com/abhinav/tmux-fastcopy/tree/main)||0.14.1|easymotion-style text copying for tmux.|
|[**userChromeJS**](https://github.com/benzBrake/userChrome.js-Loader)||2024-07-09|Firefox scripts |
|[**zpmod**](https://github.com/z-shell/zpmod)||v1.1.0|Zsh module transparently and automatically compiles sourced scripts|
</details>

### darwin

<details>
<summary>Only support for <b>aarch64-darwin</b>, <b>x86_64-darwin</b>, Most <b>GUI packages</b> only support <b>aarch64-darwin</b>. , Total: <b>10</b> packages </summary>

|name|broken system|version|description|
|:---|:---|:---|:---|
|[**aerospace**](https://github.com/nikitabobko/AeroSpace)||0.15.2-Beta|AeroSpace is an i3-like tiling window manager for macOS|
|[**dutis**](https://github.com/tsonglew/dutis)||2024-03-20|A command-line tool to select default applications, based on duti|
|[**EmacsClient**](None)||29.2|None|
|[**firefox-esr**](http://www.mozilla.com/en-US/firefox/)||128.3.1esr|Mozilla Firefox, free web browser (binary package)|
|[**lporg**](https://github.com/blacktop/lporg)||20.4.32|Organize Your macOS Launchpad Apps|
|[**mkalias**](https://github.com/reckenrode/mkalias)||0.3.2|Simple command-line tool to create Finder aliases|
|[**pngpaste**](https://github.com/jcsalterego/pngpaste)||0.2.3|Paste PNG into files, much like pbpaste does for text. |
|[**switchaudio-osx**](https://github.com/deweller/switchaudio-osx)||1.2.2|Change the audio source for Mac OS X from the command line|
|[**yabai-bin**](https://github.com/koekeishiya/yabai)||7.1.4|A tiling window manager for macOS based on binary space partitioning|
|[**yabai-zsh-completions**](https://github.com/Amar1729/yabai-zsh-completions)||2023-11-13|zsh completions for yabai, the tiling window manager|
</details>

### firefox-addons

<details>
<summary><b>firefox extension</b>, default support for all systems that support firefox. , Total: <b>18</b> packages </summary>

|name|broken system|version|description|
|:---|:---|:---|:---|
|[**auto-tab-discard**](https://webextension.org/listing/tab-discard.html)||0.6.7|Dark Reader Chrome and Firefox extension|
|[**browserpass-ce**](https://github.com/browserpass/browserpass-extension)||3.8.0|Browserpass is a browser extension for Firefox and Chrome to retrieve login details from zx2c4's pass (<a href="https://prod.outgoing.prod.webservices.mozgcp.net/v1/fcd8dcb23434c51a78197a1c25d3e2277aa1bc764c827b4b4726ec5a5657eb64/http%3A//passwordstore.org" rel="nofollow">passwordstore.org</a>) straight from your browser. Tags: passwordstore, password store, password manager, passwordmanager, gpg|
|[**chrome-mask**](https://github.com/denschub/chrome-mask)||4.2.0|Makes Firefox wear a mask to look like Chrome.|
|[**darkreader**](https://darkreader.org/)||4.9.95|Dark Reader Chrome and Firefox extension|
|[**download-with-aria2**](https://github.com/jc3213/download_with_aria2)||4.11.3.2869|Browser extension for aria2c json-rpc |
|[**easy-image-blocker**](https://addons.mozilla.org/en-US/firefox/addon/easy-image-blocker/)||3.1.5|Easy Image Blocker is the Add-on to control the loading of the image.|
|[**immersive-translate**](https://immersivetranslate.com/)||1.10.2|Immersive Dual Web Page Translation Extension |
|[**kiss-translator**](https://github.com/fishjar/kiss-translator)||1.8.11|Simple, open source bilingual translation extension & Greasemonkey script|
|[**noscript**](https://noscript.net/)||11.4.42|NoScript Security Suite|
|[**privacy-pass**](https://github.com/cloudflare/pp-browser-extension)||4.0.2|Client for Privacy Pass protocol providing unlinkable cryptographic tokens|
|[**raindropio**](https://app.raindrop.io/)||6.6.24|All-in-one bookmark manager|
|[**sidebery**](https://github.com/mbnuqw/sidebery)||v5.2.0|Firefox extension for managing tabs and bookmarks in sidebar|
|[**styl-us**](https://add0n.com/stylus.html)||1.5.51|Stylus - Userstyles Manager|
|[**surfingkeys_ff**](https://github.com/brookhong/Surfingkeys)||1.16.1|Map your keys for web surfing, expand your browser with javascript and keyboard. |
|[**ublock-origin**](https://github.com/gorhill/uBlock)||1.60.0|uBlock Origin - An efficient blocker for Chromium and Firefox. Fast and lean. |
|[**user-agent-string-switcher**](https://add0n.com/useragent-switcher.html)||0.5.0|User-Agent Switcher and Manager|
|[**violentmonkey**](https://violentmonkey.github.io)||2.26.0|An open source userscript manager.|
|[**zeroomega**](https://github.com/zero-peak/ZeroOmega)||3.3.14| Manage and switch between multiple proxies quickly & easily.|
</details>

### python3-apps

<details>
<summary>Installing <b>python programs</b> with nix. , Total: <b>5</b> packages </summary>

|name|broken system|version|description|
|:---|:---|:---|:---|
|[**about-time**](None)||4.2.1|None|
|[**alive-progress**](None)||3.1.5|None|
|[**musicdl**](https://github.com/CharlesPikachu/musicdl)||2023-02-22|A lightweight music downloader written in pure python.|
|[**sd**](None)||0.2.3|My system command line|
|[**websocket-bridge-python**](None)||0.0.2|None|
</details>

