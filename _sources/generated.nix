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
    version = "0.14.1-Beta";
    src = fetchurl {
      url = "https://github.com/nikitabobko/AeroSpace/releases/download/v0.14.1-Beta/AeroSpace-v0.14.1-Beta.zip";
      sha256 = "sha256-KgPeEX++zvdHwuZr+RcjOEa9kMJulu8OW6X56kmf3Qg=";
    };
  };
  airbattery = {
    pname = "airbattery";
    version = "1.4.9";
    src = fetchurl {
      url = "https://github.com/lihaoyun6/AirBattery/releases/download/1.4.9/AirBattery_v1.4.9.dmg";
      sha256 = "sha256-J/mHDQqSnjq2h2yg1jVzEjRnMAIDDqcHDB/hdF9kYUg=";
    };
  };
  alexandria = {
    pname = "alexandria";
    version = "0.12";
    src = fetchurl {
      url = "https://github.com/btpf/Alexandria/releases/download/v0.12/Alexandria_0.12.0_x64.dmg";
      sha256 = "sha256-mmQFu3Ym+jYRu9pN9SSmTQZ37e//1Ck86BCFrTVDpFg=";
    };
  };
  alist = {
    pname = "alist";
    version = "v3.36.0";
    src = fetchFromGitHub {
      owner = "alist-org";
      repo = "alist";
      rev = "v3.36.0";
      fetchSubmodules = false;
      sha256 = "sha256-l0/DS7ZSuto8QHvSf1ae7wy/a7yqp05koWpb+ExvJJk=";
    };
  };
  alist-web = {
    pname = "alist-web";
    version = "3.36.0";
    src = fetchurl {
      url = "https://github.com/alist-org/alist-web/releases/download/3.36.0/dist.tar.gz";
      sha256 = "sha256-uZfT7PkvRHzB2sqbGum53D8oRFWJ2z3AVBdOzBWmAKk=";
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
    version = "e4b292c99127595ca9c5a3736eb9eb08f3373c48";
    src = fetchFromGitHub {
      owner = "nilaoda";
      repo = "BBDown";
      rev = "e4b292c99127595ca9c5a3736eb9eb08f3373c48";
      fetchSubmodules = false;
      sha256 = "sha256-D4H+oeRelfENa69hXn7KfNZed6ULSx0gvb8Ju3LG5UA=";
    };
    date = "2024-08-02";
  };
  calibre = {
    pname = "calibre";
    version = "7.16.0";
    src = fetchurl {
      url = "https://download.calibre-ebook.com/7.16.0/calibre-7.16.0.dmg";
      sha256 = "sha256-G85ym8GYH8ylox/VleJIsQ5KQF0O3rpffD3U1HJOGGc=";
    };
  };
  calibrepath = {
    pname = "calibrepath";
    version = "7.16.0";
    src = fetchurl {
      url = "https://github.com/Cirn09/calibre-do-not-translate-my-path/releases/download/v7.16.0/mac-patch-backend+update-v7.16.0.zip";
      sha256 = "sha256-857M2GsR+wy/uTptvGIaXThrdILebIbazCQPerRbPJ8=";
    };
  };
  chatgpt = {
    pname = "chatgpt";
    version = "1.1.0";
    src = fetchurl {
      url = "https://github.com/lencx/ChatGPT/releases/download/v1.1.0/ChatGPT_1.1.0_macos_aarch64.dmg";
      sha256 = "sha256-+HC6E1rZkHFUdMuwOLWzisuNCGQIA+LHnIeOIQ9IAPY=";
    };
  };
  clash-nyanpasu = {
    pname = "clash-nyanpasu";
    version = "1.5.1";
    src = fetchurl {
      url = "https://github.com/keiko233/clash-nyanpasu/releases/download/v1.5.1/Clash.Nyanpasu_1.5.1_aarch64.dmg";
      sha256 = "sha256-ZB61L5Z8bfFAuanAYn6yeHha+gfL4j6fu++w3nEq0yQ=";
    };
  };
  clash-verge = {
    pname = "clash-verge";
    version = "1.7.5";
    src = fetchurl {
      url = "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v1.7.5/Clash.Verge_1.7.5_aarch64.dmg";
      sha256 = "sha256-IzCCpIQh1ew4z1JsCO+NJ2Rwua/9Q/bMw7ulDG89chE=";
    };
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
    version = "4.9.88";
    src = fetchurl {
      url = "https://github.com/darkreader/darkreader/releases/download/v4.9.88/darkreader-firefox.xpi";
      sha256 = "sha256-f9vab5mGDAD6OjffSARHbx0LyAJaZ9J8KfJHr7xv0Gs=";
    };
  };
  dashplayer = {
    pname = "dashplayer";
    version = "4.2.3";
    src = fetchurl {
      url = "https://github.com/solidSpoon/DashPlayer/releases/download/v4.2.3/DashPlayer-4.2.3-arm64.dmg";
      sha256 = "sha256-gohfwjxC6l1bM4p/0ph/xXdbWm2cbyiU0K9KTTnC52s=";
    };
  };
  deeplx = {
    pname = "deeplx";
    version = "v0.9.5";
    src = fetchFromGitHub {
      owner = "OwO-Network";
      repo = "DeepLX";
      rev = "v0.9.5";
      fetchSubmodules = false;
      sha256 = "sha256-OtdoWFD+QFYH2SzCZZPyhse+vbqfeZ1pSbn+F9wIKxU=";
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
  downkyi = {
    pname = "downkyi";
    version = "1.0.11";
    src = fetchurl {
      url = "https://github.com/yaobiao131/downkyicore/releases/download/v1.0.11/DownKyi-1.0.11-osx-arm64.dmg";
      sha256 = "sha256-mI2NJ1MAWYvTn4zhKvrlvL3Ozabfc0NICTh/VObBP5Y=";
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
    version = "ff462afe5e971411e9738305ac6afd67a0e041bb";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/ff462afe5e971411e9738305ac6afd67a0e041bb/patches/emacs-28/no-frame-refocus-cocoa.patch";
      sha256 = "sha256-+1d33IkKoHNJ8UOuZcK89D7a1v6/1WSwGiI1xaFfyr0=";
    };
    date = "2024-08-05";
  };
  "emacs29.poll" = {
    pname = "emacs29.poll";
    version = "ff462afe5e971411e9738305ac6afd67a0e041bb";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/ff462afe5e971411e9738305ac6afd67a0e041bb/patches/emacs-29/poll.patch";
      sha256 = "sha256-BS6srFt72GtGb5o9GL/5NX8rl1F/RjoJ5MUSVb2xRkg=";
    };
    date = "2024-08-05";
  };
  "emacs29.role-patch" = {
    pname = "emacs29.role-patch";
    version = "ff462afe5e971411e9738305ac6afd67a0e041bb";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/ff462afe5e971411e9738305ac6afd67a0e041bb/patches/emacs-28/fix-window-role.patch";
      sha256 = "sha256-H4Qj6n5uZsmsbdjjexGZctqhJk3gAXKiSnmnEO/LgTA=";
    };
    date = "2024-08-05";
  };
  "emacs29.round-undecorated-frame" = {
    pname = "emacs29.round-undecorated-frame";
    version = "ff462afe5e971411e9738305ac6afd67a0e041bb";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/ff462afe5e971411e9738305ac6afd67a0e041bb/patches/emacs-29/round-undecorated-frame.patch";
      sha256 = "sha256-dFH4D1WYQOVOagUuVdEQB3irxV+Y8dDAOKJOJXc/KHQ=";
    };
    date = "2024-08-05";
  };
  "emacs29.system-appearance" = {
    pname = "emacs29.system-appearance";
    version = "ff462afe5e971411e9738305ac6afd67a0e041bb";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/ff462afe5e971411e9738305ac6afd67a0e041bb/patches/emacs-28/system-appearance.patch";
      sha256 = "sha256-1u4VmDmzi2r1Ode5vf8jEmPkUcH9Qu7A0SUxjJ24zZI=";
    };
    date = "2024-08-05";
  };
  "emacs30.poll" = {
    pname = "emacs30.poll";
    version = "ff462afe5e971411e9738305ac6afd67a0e041bb";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/ff462afe5e971411e9738305ac6afd67a0e041bb/patches/emacs-30/poll.patch";
      sha256 = "sha256-Weh2+C5v2ORYO8JFYzntpPmJyGseFqArByZwLpX2CCU=";
    };
    date = "2024-08-05";
  };
  "emacs30.role-patch" = {
    pname = "emacs30.role-patch";
    version = "ff462afe5e971411e9738305ac6afd67a0e041bb";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/ff462afe5e971411e9738305ac6afd67a0e041bb/patches/emacs-28/fix-window-role.patch";
      sha256 = "sha256-H4Qj6n5uZsmsbdjjexGZctqhJk3gAXKiSnmnEO/LgTA=";
    };
    date = "2024-08-05";
  };
  "emacs30.round-undecorated-frame" = {
    pname = "emacs30.round-undecorated-frame";
    version = "ff462afe5e971411e9738305ac6afd67a0e041bb";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/ff462afe5e971411e9738305ac6afd67a0e041bb/patches/emacs-30/round-undecorated-frame.patch";
      sha256 = "sha256-dFH4D1WYQOVOagUuVdEQB3irxV+Y8dDAOKJOJXc/KHQ=";
    };
    date = "2024-08-05";
  };
  "emacs30.system-appearance" = {
    pname = "emacs30.system-appearance";
    version = "ff462afe5e971411e9738305ac6afd67a0e041bb";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/ff462afe5e971411e9738305ac6afd67a0e041bb/patches/emacs-30/system-appearance.patch";
      sha256 = "sha256-nrPOgGQAJb/5brrrWJNDARY2jWNJ9OsMtO+LPVhHfbY=";
    };
    date = "2024-08-05";
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
    version = "v0.2.30";
    src = fetchFromGitHub {
      owner = "kingwingfly";
      repo = "fav";
      rev = "v0.2.30";
      fetchSubmodules = false;
      sha256 = "sha256-XfPUlqb/P9cZVqtN4llgnSBWjKnjbOvzAgAcuYFy+L8=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./fav-v0.2.30/Cargo.lock;
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
    version = "0.27.0";
    src = fetchFromGitHub {
      owner = "encode";
      repo = "httpx";
      rev = "0.27.0";
      fetchSubmodules = false;
      sha256 = "sha256-13EnSzrCkseK6s6Yz9OpLzqo/2PTFiB31m5fAIJLoZg=";
    };
  };
  lazyvim-star = {
    pname = "lazyvim-star";
    version = "cb6349c8ae922d1c5745574f4d17b44f2731d451";
    src = fetchFromGitHub {
      owner = "LazyVim";
      repo = "starter";
      rev = "cb6349c8ae922d1c5745574f4d17b44f2731d451";
      fetchSubmodules = false;
      sha256 = "sha256-nB63tBRIU9Ma9Sv/9xNCy4563HJ2DYqQshbExN/PUo0=";
    };
    date = "2024-07-20";
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
    version = "1.5-jukebox";
    src = fetchFromGitHub {
      owner = "gmt4";
      repo = "mpvc";
      rev = "1.5-jukebox";
      fetchSubmodules = false;
      sha256 = "sha256-KAns7WR9xPvSk7zA4zBs5TEbpl5pE9r+qkLWDeNiqbc=";
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
  neovide = {
    pname = "neovide";
    version = "0.13.3";
    src = fetchurl {
      url = "https://github.com/neovide/neovide/releases/download/0.13.3/Neovide-aarch64-apple-darwin.dmg";
      sha256 = "sha256-0XiDoasWlMJNZwmGzU9YVt/t6RNMu0kEJg5+duYU3qA=";
    };
  };
  next-chat = {
    pname = "next-chat";
    version = "2.14.1";
    src = fetchurl {
      url = "https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web/releases/download/v2.14.1/NextChat_2.14.1_universal.dmg";
      sha256 = "sha256-E6Tw7BpbLSn5sELo51lBK1XZIjnZYx/2hWAEBbWloyI=";
    };
  };
  pearcleaner = {
    pname = "pearcleaner";
    version = "3.8.4";
    src = fetchurl {
      url = "https://github.com/alienator88/Pearcleaner/releases/download/3.8.4/Pearcleaner.zip";
      sha256 = "sha256-8SoHpgBlwesAYf6rclGq+vM18ChvOigJgIOE7E7xsKk=";
    };
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
    version = "release-4.6.5.10";
    src = fetchFromGitHub {
      owner = "c0re100";
      repo = "qBittorrent-Enhanced-Edition";
      rev = "release-4.6.5.10";
      fetchSubmodules = false;
      sha256 = "sha256-Yy0DUTz1lWkseh9x1xnHJCI89BKqi/D7zUn/S+qC+kM=";
    };
  };
  quickrecorder = {
    pname = "quickrecorder";
    version = "1.4.5";
    src = fetchurl {
      url = "https://github.com/lihaoyun6/QuickRecorder/releases/download/1.4.5/QuickRecorder_v1.4.5.dmg";
      sha256 = "sha256-n2Yg9YdFOYn1ljHKxeIZ949guJ7YY1kpcECoiKx2lmw=";
    };
  };
  ryujinx = {
    pname = "ryujinx";
    version = "1.1.1373";
    src = fetchurl {
      url = "https://github.com/Ryujinx/release-channel-master/releases/download/1.1.1373/ryujinx-1.1.1373-macos_universal.app.tar.gz";
      sha256 = "sha256-lwhcSNwP4E2+VtVdOhKeSnMc7XqtIWwt3OSIkdHl9nE=";
    };
  };
  ryusak = {
    pname = "ryusak";
    version = "1.6.3";
    src = fetchurl {
      url = "https://github.com/FennyFatal/RyuSAK/releases/download/v1.6.3-experimental/RyuSAK-darwin-arm64-1.6.3.zip";
      sha256 = "sha256-iohH/P56qaFnrS/WhoNxZr66h8cdwCuFfCUDfHF1tho=";
    };
  };
  sd = {
    pname = "sd";
    version = "v0.2.1";
    src = fetchFromGitHub {
      owner = "shanyouli";
      repo = "sd";
      rev = "v0.2.1";
      fetchSubmodules = false;
      sha256 = "sha256-4rVHRO4m0wLQYntsE4fIbgFYO4T8JNORebnMWP5/m1k=";
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
  spotube = {
    pname = "spotube";
    version = "3.8.0";
    src = fetchurl {
      url = "https://github.com/KRTirtho/spotube/releases/download/v3.8.0/Spotube-macos-universal.dmg";
      sha256 = "sha256-qQDbGRnia8JAclm2AgT2FCxhYS6WoNuDWIMbG76pDB0=";
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
  tmexclude = {
    pname = "tmexclude";
    version = "0.2.2";
    src = fetchurl {
      url = "https://github.com/PhotonQuantum/tmexclude/releases/download/v0.2.2/TimeMachine.Exclude_0.2.2_universal.dmg";
      sha256 = "sha256-KIRSb/W6Bulmkj0VVYIrr3tubepc5msk3uL/L112Gak=";
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
  upic = {
    pname = "upic";
    version = "0.21.1";
    src = fetchurl {
      url = "https://github.com/gee1k/uPic/releases/download/v0.21.1/uPic.zip";
      sha256 = "sha256-EVLi85lcwz0W12Q0hhinCp+wZ/Kxf1SKgTZGgJqhFUw=";
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
  vimmotion = {
    pname = "vimmotion";
    version = "1.2.3";
    src = fetchurl {
      url = "https://github.com/dwarvesf/VimMotionApp/releases/download/v1.2.3/VimMotion.1.2.3.dmg";
      sha256 = "sha256-wUu5NVtRkdFaXHIkxIdjvxZ8qSavOSBtMIsc+aygDAA=";
    };
  };
  websocket-bridge-python = {
    pname = "websocket-bridge-python";
    version = "0.0.2";
    src = fetchurl {
      url = "https://pypi.org/packages/source/w/websocket_bridge_python/websocket_bridge_python-0.0.2.tar.gz";
      sha256 = "sha256-J9HGD3PSavZQwh2eZPbM6isdknZ1M2nkL5WHlYjRju8=";
    };
  };
  wiliwili = {
    pname = "wiliwili";
    version = "1.4.1";
    src = fetchurl {
      url = "https://github.com/xfangfang/wiliwili/releases/download/v1.4.1/wiliwili-macOS-AppleSilicon.dmg";
      sha256 = "sha256-iy7dJix2lq3eUQCcHg3cK/QcG4nH1veJyOtakVc36Mo=";
    };
  };
  yabai = {
    pname = "yabai";
    version = "v7.1.2";
    src = fetchFromGitHub {
      owner = "koekeishiya";
      repo = "yabai";
      rev = "v7.1.2";
      fetchSubmodules = false;
      sha256 = "sha256-H+7vH6AjP6HQ1ifXe8qlLSh0FQu8KJkwr+38C5akk/c=";
    };
  };
  yabai-bin = {
    pname = "yabai-bin";
    version = "7.1.2";
    src = fetchurl {
      url = "https://github.com/koekeishiya/yabai/releases/download/v7.1.2/yabai-v7.1.2.tar.gz";
      sha256 = "sha256-RIYo5Ilqbfs4kqYKSrztYLAqgvlPXqaEenVnMJvTWDk=";
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
  zy-player = {
    pname = "zy-player";
    version = "3.3.7";
    src = fetchurl {
      url = "https://github.com/Hiram-Wong/ZyPlayer/releases/download/v3.3.7/zyplayer-mac-3.3.7-arm64.dmg";
      sha256 = "sha256-2Ft17zCRzWXOcBz/ckgHLhAgR0g+7Wfz0KJrcNXqo2M=";
    };
  };
}
