# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  about-time = {
    pname = "about-time";
    version = "4.2.1";
    src = fetchurl {
      url = "https://pypi.org/packages/source/a/about-time/about-time-4.2.1.tar.gz";
      sha256 = "sha256-alOIYtM85n2ZdCnRSZgxDh2/2my32bv795nEcJhH/s4=";
    };
  };
  aerospace = {
    pname = "aerospace";
    version = "0.14.2-Beta";
    src = fetchurl {
      url = "https://github.com/nikitabobko/AeroSpace/releases/download/v0.14.2-Beta/AeroSpace-v0.14.2-Beta.zip";
      sha256 = "sha256-xOIP51kFQTy9RbCGQo5gJGMzl/WhZlJ+lCtMOaMCnB8=";
    };
  };
  alist = {
    pname = "alist";
    version = "v3.37.4";
    src = fetchFromGitHub {
      owner = "alist-org";
      repo = "alist";
      rev = "v3.37.4";
      fetchSubmodules = false;
      sha256 = "sha256-xNkcekxb0Aw7trBPxc0/Akb0ntx4DKM9b+i5SQju2lw=";
    };
  };
  alist-web = {
    pname = "alist-web";
    version = "3.37.1";
    src = fetchurl {
      url = "https://github.com/alist-org/alist-web/releases/download/3.37.1/dist.tar.gz";
      sha256 = "sha256-DKH861KRxZ1bXcwPPocerJZIXTmrzoSV8etRDMErzPY=";
    };
  };
  alive-progress = {
    pname = "alive-progress";
    version = "3.1.5";
    src = fetchurl {
      url = "https://pypi.org/packages/source/a/alive-progress/alive-progress-3.1.5.tar.gz";
      sha256 = "sha256-QuOZpmyBUNxQdgLf97eVPxBe8R+vl92qbSexy/RcTJg=";
    };
  };
  bbdown = {
    pname = "bbdown";
    version = "99f9ed49fa81b8488928eef5aef45d4d14aeabd3";
    src = fetchFromGitHub {
      owner = "nilaoda";
      repo = "BBDown";
      rev = "99f9ed49fa81b8488928eef5aef45d4d14aeabd3";
      fetchSubmodules = false;
      sha256 = "sha256-pWqh8af/MlHmbPKtccCePBVEn/R8dd49XQ2zMmyNfSo=";
    };
    date = "2024-09-01";
  };
  clash2singbox = {
    pname = "clash2singbox";
    version = "v0.1.4";
    src = fetchFromGitHub {
      owner = "xmdhs";
      repo = "clash2singbox";
      rev = "v0.1.4";
      fetchSubmodules = false;
      sha256 = "sha256-qEv5lmuu4UWaxmCQ0sb21TMJVhYaW7VscD6O+dOWjgE=";
    };
  };
  darkreader = {
    pname = "darkreader";
    version = "4.9.92";
    src = fetchurl {
      url = "https://github.com/darkreader/darkreader/releases/download/v4.9.92/darkreader-firefox.xpi";
      sha256 = "sha256-kNPzdCnP0TV+yDEmWZZjXpk3ROe5lzt20hUwq4lRSGA=";
    };
  };
  deeplx = {
    pname = "deeplx";
    version = "v0.9.7";
    src = fetchFromGitHub {
      owner = "OwO-Network";
      repo = "DeepLX";
      rev = "v0.9.7";
      fetchSubmodules = false;
      sha256 = "sha256-A5mMjMaG01XmJM7eqnCV6aB2L38Z9N1NITA4d9Q3I0A=";
    };
  };
  dict2xml = {
    pname = "dict2xml";
    version = "release-1.7.6";
    src = fetchFromGitHub {
      owner = "delfick";
      repo = "python-dict2xml";
      rev = "release-1.7.6";
      fetchSubmodules = false;
      sha256 = "sha256-5GnIVpG2xHKYv27sSjjmm8JsZ1YR9Mvc3SqE4SnE84o=";
    };
  };
  dutis = {
    pname = "dutis";
    version = "e1c3f9ba222552350964b51389507ea0be93057c";
    src = fetchFromGitHub {
      owner = "tsonglew";
      repo = "dutis";
      rev = "e1c3f9ba222552350964b51389507ea0be93057c";
      fetchSubmodules = false;
      sha256 = "sha256-hPvQ6M+foEzQEcPYYLGzVJ69moAkfMe9boKQ/2ajFtI=";
    };
    date = "2024-03-20";
  };
  "emacs29.no-frame-refocus-cocoa" = {
    pname = "emacs29.no-frame-refocus-cocoa";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-28/no-frame-refocus-cocoa.patch";
      sha256 = "sha256-+1d33IkKoHNJ8UOuZcK89D7a1v6/1WSwGiI1xaFfyr0=";
    };
    date = "2024-09-17";
  };
  "emacs29.poll" = {
    pname = "emacs29.poll";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-29/poll.patch";
      sha256 = "sha256-BS6srFt72GtGb5o9GL/5NX8rl1F/RjoJ5MUSVb2xRkg=";
    };
    date = "2024-09-17";
  };
  "emacs29.role-patch" = {
    pname = "emacs29.role-patch";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-28/fix-window-role.patch";
      sha256 = "sha256-H4Qj6n5uZsmsbdjjexGZctqhJk3gAXKiSnmnEO/LgTA=";
    };
    date = "2024-09-17";
  };
  "emacs29.round-undecorated-frame" = {
    pname = "emacs29.round-undecorated-frame";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-29/round-undecorated-frame.patch";
      sha256 = "sha256-dFH4D1WYQOVOagUuVdEQB3irxV+Y8dDAOKJOJXc/KHQ=";
    };
    date = "2024-09-17";
  };
  "emacs29.system-appearance" = {
    pname = "emacs29.system-appearance";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-28/system-appearance.patch";
      sha256 = "sha256-1u4VmDmzi2r1Ode5vf8jEmPkUcH9Qu7A0SUxjJ24zZI=";
    };
    date = "2024-09-17";
  };
  "emacs30.poll" = {
    pname = "emacs30.poll";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-30/poll.patch";
      sha256 = "sha256-Weh2+C5v2ORYO8JFYzntpPmJyGseFqArByZwLpX2CCU=";
    };
    date = "2024-09-17";
  };
  "emacs30.role-patch" = {
    pname = "emacs30.role-patch";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-28/fix-window-role.patch";
      sha256 = "sha256-H4Qj6n5uZsmsbdjjexGZctqhJk3gAXKiSnmnEO/LgTA=";
    };
    date = "2024-09-17";
  };
  "emacs30.round-undecorated-frame" = {
    pname = "emacs30.round-undecorated-frame";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-30/round-undecorated-frame.patch";
      sha256 = "sha256-dFH4D1WYQOVOagUuVdEQB3irxV+Y8dDAOKJOJXc/KHQ=";
    };
    date = "2024-09-17";
  };
  "emacs30.system-appearance" = {
    pname = "emacs30.system-appearance";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-30/system-appearance.patch";
      sha256 = "sha256-nrPOgGQAJb/5brrrWJNDARY2jWNJ9OsMtO+LPVhHfbY=";
    };
    date = "2024-09-17";
  };
  "emacs31.poll" = {
    pname = "emacs31.poll";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-30/poll.patch";
      sha256 = "sha256-Weh2+C5v2ORYO8JFYzntpPmJyGseFqArByZwLpX2CCU=";
    };
    date = "2024-09-17";
  };
  "emacs31.role-patch" = {
    pname = "emacs31.role-patch";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-28/fix-window-role.patch";
      sha256 = "sha256-H4Qj6n5uZsmsbdjjexGZctqhJk3gAXKiSnmnEO/LgTA=";
    };
    date = "2024-09-17";
  };
  "emacs31.round-undecorated-frame" = {
    pname = "emacs31.round-undecorated-frame";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-30/round-undecorated-frame.patch";
      sha256 = "sha256-dFH4D1WYQOVOagUuVdEQB3irxV+Y8dDAOKJOJXc/KHQ=";
    };
    date = "2024-09-17";
  };
  "emacs31.system-appearance" = {
    pname = "emacs31.system-appearance";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/cc3280dfdf7562dd69c97d0dfa872b1c3313a18a/patches/emacs-30/system-appearance.patch";
      sha256 = "sha256-nrPOgGQAJb/5brrrWJNDARY2jWNJ9OsMtO+LPVhHfbY=";
    };
    date = "2024-09-17";
  };
  emacsclient = {
    pname = "emacsclient";
    version = "917f2f2694019d534098f5e2e365b5f6e5ddbd37";
    src = fetchurl {
      url = "https://github.com/nashamri/spacemacs-logo/raw/917f2f2694019d534098f5e2e365b5f6e5ddbd37/spacemacs.icns";
      sha256 = "sha256-s9uLfPpLxbziS8TcHt47dSxxhse1TAmZTqtexOqkiQA=";
    };
    date = "2018-08-26";
  };
  fav = {
    pname = "fav";
    version = "v0.2.33";
    src = fetchFromGitHub {
      owner = "kingwingfly";
      repo = "fav";
      rev = "v0.2.33";
      fetchSubmodules = false;
      sha256 = "sha256-B/2mXMQpo+ZpofhKYilDQnlcldnZdAo6p5Hck8ECO4E=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./fav-v0.2.33/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  go-musicfox = {
    pname = "go-musicfox";
    version = "v4.5.3";
    src = fetchFromGitHub {
      owner = "go-musicfox";
      repo = "go-musicfox";
      rev = "v4.5.3";
      fetchSubmodules = false;
      sha256 = "sha256-qf4XAAfWWlHAnNGhXaYpnjj+2z+/lWOHaTyv8R4UDgQ=";
    };
  };
  httpx = {
    pname = "httpx";
    version = "0.27.2";
    src = fetchFromGitHub {
      owner = "encode";
      repo = "httpx";
      rev = "0.27.2";
      fetchSubmodules = false;
      sha256 = "sha256-N0ztVA/KMui9kKIovmOfNTwwrdvSimmNkSvvC+3gpck=";
    };
  };
  lporg = {
    pname = "lporg";
    version = "v20.4.32";
    src = fetchFromGitHub {
      owner = "blacktop";
      repo = "lporg";
      rev = "v20.4.32";
      fetchSubmodules = false;
      sha256 = "sha256-g8zZZ/uQeoJQIzpQY3oMUuWMu4/8OnaOLeLvaii+Tmk=";
    };
  };
  maple-mono = {
    pname = "maple-mono";
    version = "6.4";
    src = fetchurl {
      url = "https://github.com/subframe7536/maple-font/releases/download/v6.4/MapleMono-ttf.zip";
      sha256 = "sha256-a06JLIP5aVb9SeEz6kw+LqKy0ydCgaUlPDFWA2Y0G8Q=";
    };
  };
  maple-sc-nf = {
    pname = "maple-sc-nf";
    version = "6.4";
    src = fetchurl {
      url = "https://github.com/subframe7536/Maple-font/releases/download/v6.4/MapleMono-SC-NF.zip";
      sha256 = "sha256-SbXWkrpLJUrq+Jt1h3GBP9md5TbYpPchdiR0oEDMAgY=";
    };
  };
  mpvc = {
    pname = "mpvc";
    version = "1.5-vinyl";
    src = fetchFromGitHub {
      owner = "gmt4";
      repo = "mpvc";
      rev = "1.5-vinyl";
      fetchSubmodules = false;
      sha256 = "sha256-usZCIv1gQsXQ7Z8MOxYGy60O+UBpLlQEEuLerHIuYkQ=";
    };
  };
  musicdl = {
    pname = "musicdl";
    version = "ae213b2e5867fa12a6fa2789e24ea792aab38540";
    src = fetchFromGitHub {
      owner = "CharlesPikachu";
      repo = "musicdl";
      rev = "ae213b2e5867fa12a6fa2789e24ea792aab38540";
      fetchSubmodules = false;
      sha256 = "sha256-AoMtlyRiceDzNXKz1K/EH5+/yU2B+UlEso5kjL5ojlI=";
    };
    date = "2023-02-22";
  };
  musicn = {
    pname = "musicn";
    version = "v1.5.0";
    src = fetchFromGitHub {
      owner = "zonemeen";
      repo = "musicn";
      rev = "v1.5.0";
      fetchSubmodules = false;
      sha256 = "sha256-jnS3NwxguAu4SJNFTvk6HgYF0eVw8/L7qC4o1K+WVwE=";
    };
  };
  nh_darwin = {
    pname = "nh_darwin";
    version = "642220e43e1b1fec3b1894fb25ad36c6831d0cab";
    src = fetchFromGitHub {
      owner = "ToyVo";
      repo = "nh_darwin";
      rev = "642220e43e1b1fec3b1894fb25ad36c6831d0cab";
      fetchSubmodules = false;
      sha256 = "sha256-CRP0fja7sT9aNJCKV+VUGrMZCslMptEtK0/JAjNAoQU=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./nh_darwin-642220e43e1b1fec3b1894fb25ad36c6831d0cab/Cargo.lock;
      outputHashes = {
        
      };
    };
    date = "2024-09-11";
  };
  pngpaste = {
    pname = "pngpaste";
    version = "0.2.3";
    src = fetchFromGitHub {
      owner = "jcsalterego";
      repo = "pngpaste";
      rev = "0.2.3";
      fetchSubmodules = false;
      sha256 = "sha256-uvajxSelk1Wfd5is5kmT2fzDShlufBgC0PDCeabEOSE=";
    };
  };
  qbittorrent = {
    pname = "qbittorrent";
    version = "release-4.6.7.10";
    src = fetchFromGitHub {
      owner = "c0re100";
      repo = "qBittorrent-Enhanced-Edition";
      rev = "release-4.6.7.10";
      fetchSubmodules = false;
      sha256 = "sha256-Mr376nH2pE6NMF9IdDhZULwqkRr7472OZnKO86hb6ZI=";
    };
  };
  sd = {
    pname = "sd";
    version = "v0.2.3";
    src = fetchFromGitHub {
      owner = "shanyouli";
      repo = "sd";
      rev = "v0.2.3";
      fetchSubmodules = false;
      sha256 = "sha256-NXD0xj08LOz7PgRko6sjDMe9+00jVwiQXeOTjSN8rQU=";
    };
  };
  seam = {
    pname = "seam";
    version = "v_cli.0.1.39";
    src = fetchFromGitHub {
      owner = "Borber";
      repo = "seam";
      rev = "v_cli.0.1.39";
      fetchSubmodules = false;
      sha256 = "sha256-rWbswgVQNA006gi9G+Vma+y0NbMDC0/P6SqHwxxvky8=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./seam-v_cli.0.1.39/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  sidebery = {
    pname = "sidebery";
    version = "v5.2.0";
    src = fetchFromGitHub {
      owner = "mbnuqw";
      repo = "sidebery";
      rev = "v5.2.0";
      fetchSubmodules = false;
      sha256 = "sha256-83n0aX5mJYf1yYamuM+DelkpOGLRZqkXpTgQMAmMLXI=";
    };
  };
  switchaudio-osx = {
    pname = "switchaudio-osx";
    version = "1.2.2";
    src = fetchFromGitHub {
      owner = "deweller";
      repo = "switchaudio-osx";
      rev = "1.2.2";
      fetchSubmodules = false;
      sha256 = "sha256-AZJn5kHK/al94ONfIHcG+W0jyMfgdJkIngN+PVj+I44=";
    };
  };
  tmux-fastcopy = {
    pname = "tmux-fastcopy";
    version = "v0.14.1";
    src = fetchFromGitHub {
      owner = "abhinav";
      repo = "tmux-fastcopy";
      rev = "v0.14.1";
      fetchSubmodules = false;
      sha256 = "sha256-j7Kk5uaC3vx4JifaAHXfLvXx6ask9YqlNKEiU5BYi+A=";
    };
  };
  userChromeJS = {
    pname = "userChromeJS";
    version = "f9ab1a2fdbb3c3efdb14ddabd90bf22b7fb7b5be";
    src = fetchFromGitHub {
      owner = "benzBrake";
      repo = "userChrome.js-Loader";
      rev = "f9ab1a2fdbb3c3efdb14ddabd90bf22b7fb7b5be";
      fetchSubmodules = false;
      sha256 = "sha256-ymblpbySU2iPo+9zOAQSuDatprGvlcd+MECq2d0lguU=";
    };
    date = "2024-07-09";
  };
  websocket-bridge-python = {
    pname = "websocket-bridge-python";
    version = "0.0.2";
    src = fetchurl {
      url = "https://pypi.org/packages/source/w/websocket_bridge_python/websocket_bridge_python-0.0.2.tar.gz";
      sha256 = "sha256-J9HGD3PSavZQwh2eZPbM6isdknZ1M2nkL5WHlYjRju8=";
    };
  };
  yabai = {
    pname = "yabai";
    version = "v7.1.3";
    src = fetchFromGitHub {
      owner = "koekeishiya";
      repo = "yabai";
      rev = "v7.1.3";
      fetchSubmodules = false;
      sha256 = "sha256-hCwI6ziUR4yuJOv4MQXh3ufbausaDrG8XfjR+jIOeC4=";
    };
  };
  yabai-bin = {
    pname = "yabai-bin";
    version = "7.1.3";
    src = fetchurl {
      url = "https://github.com/koekeishiya/yabai/releases/download/v7.1.3/yabai-v7.1.3.tar.gz";
      sha256 = "sha256-eq7nUb/a8fjXiyy+tRmAr+gv1JYNCB5MYjualCL6JaU=";
    };
  };
  yabai-zsh-completions = {
    pname = "yabai-zsh-completions";
    version = "6e38681a002e13bdcd43f461f73c53b7c11fd4e5";
    src = fetchFromGitHub {
      owner = "Amar1729";
      repo = "yabai-zsh-completions";
      rev = "6e38681a002e13bdcd43f461f73c53b7c11fd4e5";
      fetchSubmodules = false;
      sha256 = "sha256-II00E32Pnt7PO+PcTtWp4NzSUDhQJTgAPw9HdlItbhQ=";
    };
    date = "2023-11-13";
  };
  zpmod = {
    pname = "zpmod";
    version = "v1.1.0";
    src = fetchFromGitHub {
      owner = "z-shell";
      repo = "zpmod";
      rev = "v1.1.0";
      fetchSubmodules = false;
      sha256 = "sha256-vCQOn+8l9DcVJ6XbtHhr7N5IDr2Ht/JRub217ZO96Ok=";
    };
  };
}
