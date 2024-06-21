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
    version = "0.12.0-Beta";
    src = fetchurl {
      url = "https://github.com/nikitabobko/AeroSpace/releases/download/v0.12.0-Beta/AeroSpace-v0.12.0-Beta.zip";
      sha256 = "sha256-iAEwG16scvqm2uBHl8t2gOsXXf0jyKDNfpChu7WBElc=";
    };
  };
  airbattery = {
    pname = "airbattery";
    version = "1.3.9";
    src = fetchurl {
      url = "https://github.com/lihaoyun6/AirBattery/releases/download/1.3.9/AirBattery_v1.3.9.dmg";
      sha256 = "sha256-6YOqElV1Lv4zjwO63StDEAeuPJqv46l1+WWt5f1Zf1I=";
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
    version = "v3.35.0";
    src = fetchFromGitHub {
      owner = "alist-org";
      repo = "alist";
      rev = "v3.35.0";
      fetchSubmodules = false;
      sha256 = "sha256-N9WgaPzc8cuDN7N0Ny3t6ARGla0lCluzF2Mut3Pg880=";
    };
  };
  alist-web = {
    pname = "alist-web";
    version = "3.35.0";
    src = fetchurl {
      url = "https://github.com/alist-org/alist-web/releases/download/3.35.0/dist.tar.gz";
      sha256 = "sha256-lAYIwrn2TPWFrU0kFUXl8eWeX25U746iycOimZgxP8c=";
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
    version = "fb3c0b69023055b79645790c25ca18afdec6e3e0";
    src = fetchFromGitHub {
      owner = "nilaoda";
      repo = "BBDown";
      rev = "fb3c0b69023055b79645790c25ca18afdec6e3e0";
      fetchSubmodules = false;
      sha256 = "sha256-0PY8G4gtKjXdv4H3lMxGW59ozcrZocFSdB2BtmX/oMo=";
    };
    date = "2024-06-10";
  };
  calibre = {
    pname = "calibre";
    version = "7.12.0";
    src = fetchurl {
      url = "https://download.calibre-ebook.com/7.12.0/calibre-7.12.0.dmg";
      sha256 = "sha256-KDiLYhdQgP8BBRDbX72bBFBwKZ9yEd4ecHZoozYe26E=";
    };
  };
  calibrepath = {
    pname = "calibrepath";
    version = "7.12.0";
    src = fetchurl {
      url = "https://github.com/Cirn09/calibre-do-not-translate-my-path/releases/download/v7.12.0/mac-patch-backend+update-v7.12.0.zip";
      sha256 = "sha256-qqWgKxpJjtB9WpbwlV9wO8/Dk9cW4TZfvcs+U4Tr/Vs=";
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
    version = "1.3.8";
    src = fetchurl {
      url = "https://github.com/zzzgydi/clash-verge/releases/download/v1.3.8/Clash.Verge_1.3.8_aarch64.dmg";
      sha256 = "sha256-/YNwMjppWogo0adIfJ50IAzja1GzJElb+6IUmMb8jEg=";
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
    version = "4.9.86";
    src = fetchurl {
      url = "https://github.com/darkreader/darkreader/releases/download/v4.9.86/darkreader-firefox.xpi";
      sha256 = "sha256-qC9CWOkIYE6pPxr277V4+X07zUXFT7+4TNYamVQ/968=";
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
    version = "release-1.7.5";
    src = fetchFromGitHub {
      owner = "delfick";
      repo = "python-dict2xml";
      rev = "release-1.7.5";
      fetchSubmodules = false;
      sha256 = "sha256-GNvG1VFz/qkkTrKleMrq8n6kcIYtfhUlQMyCqH9uQzw=";
    };
  };
  downkyi = {
    pname = "downkyi";
    version = "1.0.10";
    src = fetchurl {
      url = "https://github.com/yaobiao131/downkyicore/releases/download/v1.0.10/DownKyi-1.0.10-osx-arm64.dmg";
      sha256 = "sha256-PiAWcc7q7nuRYY4okbCKSKNMGA1/kXDbrYHoXo/G4R4=";
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
    version = "2c9dcd167b202bcbdd4722cfca7368715ad7a3e3";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/2c9dcd167b202bcbdd4722cfca7368715ad7a3e3/patches/emacs-28/no-frame-refocus-cocoa.patch";
      sha256 = "sha256-+1d33IkKoHNJ8UOuZcK89D7a1v6/1WSwGiI1xaFfyr0=";
    };
    date = "2024-06-10";
  };
  "emacs29.poll" = {
    pname = "emacs29.poll";
    version = "2c9dcd167b202bcbdd4722cfca7368715ad7a3e3";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/2c9dcd167b202bcbdd4722cfca7368715ad7a3e3/patches/emacs-29/poll.patch";
      sha256 = "sha256-BS6srFt72GtGb5o9GL/5NX8rl1F/RjoJ5MUSVb2xRkg=";
    };
    date = "2024-06-10";
  };
  "emacs29.role-patch" = {
    pname = "emacs29.role-patch";
    version = "2c9dcd167b202bcbdd4722cfca7368715ad7a3e3";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/2c9dcd167b202bcbdd4722cfca7368715ad7a3e3/patches/emacs-28/fix-window-role.patch";
      sha256 = "sha256-H4Qj6n5uZsmsbdjjexGZctqhJk3gAXKiSnmnEO/LgTA=";
    };
    date = "2024-06-10";
  };
  "emacs29.round-undecorated-frame" = {
    pname = "emacs29.round-undecorated-frame";
    version = "2c9dcd167b202bcbdd4722cfca7368715ad7a3e3";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/2c9dcd167b202bcbdd4722cfca7368715ad7a3e3/patches/emacs-29/round-undecorated-frame.patch";
      sha256 = "sha256-dFH4D1WYQOVOagUuVdEQB3irxV+Y8dDAOKJOJXc/KHQ=";
    };
    date = "2024-06-10";
  };
  "emacs29.system-appearance" = {
    pname = "emacs29.system-appearance";
    version = "2c9dcd167b202bcbdd4722cfca7368715ad7a3e3";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/2c9dcd167b202bcbdd4722cfca7368715ad7a3e3/patches/emacs-28/system-appearance.patch";
      sha256 = "sha256-1u4VmDmzi2r1Ode5vf8jEmPkUcH9Qu7A0SUxjJ24zZI=";
    };
    date = "2024-06-10";
  };
  "emacs30.poll" = {
    pname = "emacs30.poll";
    version = "2c9dcd167b202bcbdd4722cfca7368715ad7a3e3";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/2c9dcd167b202bcbdd4722cfca7368715ad7a3e3/patches/emacs-30/poll.patch";
      sha256 = "sha256-Mbdtaigw+jttRT47v17HJZtbq/HZd7K/iKZiT6eMs+Y=";
    };
    date = "2024-06-10";
  };
  "emacs30.role-patch" = {
    pname = "emacs30.role-patch";
    version = "2c9dcd167b202bcbdd4722cfca7368715ad7a3e3";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/2c9dcd167b202bcbdd4722cfca7368715ad7a3e3/patches/emacs-28/fix-window-role.patch";
      sha256 = "sha256-H4Qj6n5uZsmsbdjjexGZctqhJk3gAXKiSnmnEO/LgTA=";
    };
    date = "2024-06-10";
  };
  "emacs30.round-undecorated-frame" = {
    pname = "emacs30.round-undecorated-frame";
    version = "2c9dcd167b202bcbdd4722cfca7368715ad7a3e3";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/2c9dcd167b202bcbdd4722cfca7368715ad7a3e3/patches/emacs-30/round-undecorated-frame.patch";
      sha256 = "sha256-dFH4D1WYQOVOagUuVdEQB3irxV+Y8dDAOKJOJXc/KHQ=";
    };
    date = "2024-06-10";
  };
  "emacs30.system-appearance" = {
    pname = "emacs30.system-appearance";
    version = "2c9dcd167b202bcbdd4722cfca7368715ad7a3e3";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/2c9dcd167b202bcbdd4722cfca7368715ad7a3e3/patches/emacs-30/system-appearance.patch";
      sha256 = "sha256-nrPOgGQAJb/5brrrWJNDARY2jWNJ9OsMtO+LPVhHfbY=";
    };
    date = "2024-06-10";
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
    version = "v0.2.29";
    src = fetchFromGitHub {
      owner = "kingwingfly";
      repo = "fav";
      rev = "v0.2.29";
      fetchSubmodules = false;
      sha256 = "sha256-PGqDGYXOplyutYZey8F2o9fCjMVReBvFf6zjY1C/EWI=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./fav-v0.2.29/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  firefox-utils = {
    pname = "firefox-utils";
    version = "b013243f1916576166a02d816651c2cc6416f63e";
    src = fetchurl {
      url = "https://github.com/xiaoxiaoflood/firefox-scripts/raw/b013243f1916576166a02d816651c2cc6416f63e/utils.zip";
      sha256 = "sha256-2LK3BGKSsFeMKLsXnMNz2ONJ/Wb07VTLSu4TwemYNOQ=";
    };
    date = "2023-02-24";
  };
  fx-folder = {
    pname = "fx-folder";
    version = "b013243f1916576166a02d816651c2cc6416f63e";
    src = fetchurl {
      url = "https://github.com/xiaoxiaoflood/firefox-scripts/raw/b013243f1916576166a02d816651c2cc6416f63e/fx-folder.zip";
      sha256 = "sha256-IAiHzJ/9YBuChVTePMmXFYtx69jX+crDe1GcAcfZ+OI=";
    };
    date = "2023-02-24";
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
    version = "0c370f4d5c537e6d41dea31b547accc8d5f70a8a";
    src = fetchFromGitHub {
      owner = "LazyVim";
      repo = "starter";
      rev = "0c370f4d5c537e6d41dea31b547accc8d5f70a8a";
      fetchSubmodules = false;
      sha256 = "sha256-ze8B6BuvQ2eK2NV6nNSqvYAl/TqbAPefvP3rUPwRg5w=";
    };
    date = "2024-06-18";
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
  lyricx = {
    pname = "lyricx";
    version = "1.6.4";
    src = fetchurl {
      url = "https://github.com/MxIris-Application-Forks/LyricsX/releases/download/v1.6.4/LyricsX.zip";
      sha256 = "sha256-nPWJBhVkWMQXmHAxNQigVCxkjJ6CStHNF850vN/gW3g=";
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
    version = "0.13.1";
    src = fetchurl {
      url = "https://github.com/neovide/neovide/releases/download/0.13.1/neovide.dmg.zip";
      sha256 = "sha256-NPIF9IO1eUlxuLscvgBdMw7V4ZLYGN+Pzqm5uXavDPQ=";
    };
  };
  next-chat = {
    pname = "next-chat";
    version = "2.12.3";
    src = fetchurl {
      url = "https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web/releases/download/v2.12.3/NextChat_2.12.3_universal.dmg";
      sha256 = "sha256-JR5Wb+nzeRFD0NbGNz8ETkbx+PFZO6yC+SoxjojwaHc=";
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
    version = "1.4.0";
    src = fetchurl {
      url = "https://github.com/lihaoyun6/QuickRecorder/releases/download/1.4.0/QuickRecorder_v1.4.0.dmg";
      sha256 = "sha256-k/vS3f8gWAJ+9W+Y0ejitU36+RKQg1TvdEVfCN18WhE=";
    };
  };
  qutebrowser = {
    pname = "qutebrowser";
    version = "3.2.0";
    src = fetchurl {
      url = "https://github.com/qutebrowser/qutebrowser/releases/download/v3.2.0/qutebrowser-3.2.0.dmg";
      sha256 = "sha256-IhCS+bf4FTaSFFpw3knUm+NZUZaJLD9xIMxabf0nFUE=";
    };
  };
  ryujinx = {
    pname = "ryujinx";
    version = "1.1.1336";
    src = fetchurl {
      url = "https://github.com/Ryujinx/release-channel-master/releases/download/1.1.1336/ryujinx-1.1.1336-macos_universal.app.tar.gz";
      sha256 = "sha256-tVvs09HiiC5HKOQL8lpNLRFmhfv23+a51LqQVYxLhuw=";
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
    version = "v0.1.2.5";
    src = fetchFromGitHub {
      owner = "shanyouli";
      repo = "sd";
      rev = "v0.1.2.5";
      fetchSubmodules = false;
      sha256 = "sha256-vUtRPmXM47VwI0eHhUwMj49HBR95Ulk+Q+X/NjyHtes=";
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
    version = "3.7.1";
    src = fetchurl {
      url = "https://github.com/KRTirtho/spotube/releases/download/v3.7.1/Spotube-macos-universal.dmg";
      sha256 = "sha256-EYgjVXO/ztIsVYzEHe14YgXbQTclQIht9Qqr8ewHU8w=";
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
  upic = {
    pname = "upic";
    version = "0.21.1";
    src = fetchurl {
      url = "https://github.com/gee1k/uPic/releases/download/v0.21.1/uPic.zip";
      sha256 = "sha256-EVLi85lcwz0W12Q0hhinCp+wZ/Kxf1SKgTZGgJqhFUw=";
    };
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
    version = "1.4.0";
    src = fetchurl {
      url = "https://github.com/xfangfang/wiliwili/releases/download/v1.4.0/wiliwili-macOS-AppleSilicon.dmg";
      sha256 = "sha256-ndowJFu/Bdx9TWZNFNdediyq/NZdkwXjq9b1SO587Kc=";
    };
  };
  yabai = {
    pname = "yabai";
    version = "v7.1.1";
    src = fetchFromGitHub {
      owner = "koekeishiya";
      repo = "yabai";
      rev = "v7.1.1";
      fetchSubmodules = false;
      sha256 = "sha256-dznMjSaS2kkyYf7JrNf1Y++Nb5YFOmk/JQP3BBrf5Bk=";
    };
  };
  yabai-bin = {
    pname = "yabai-bin";
    version = "7.1.1";
    src = fetchurl {
      url = "https://github.com/koekeishiya/yabai/releases/download/v7.1.1/yabai-v7.1.1.tar.gz";
      sha256 = "sha256-uqxP7hO4cyZRoA9acOHWMVPmEGQhZcIRGmLar3H+xE8=";
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
    version = "3.3.6";
    src = fetchurl {
      url = "https://github.com/Hiram-Wong/ZyPlayer/releases/download/v3.3.6/zyplayer-mac-3.3.6-arm64.dmg";
      sha256 = "sha256-wFBGbYXb1sMFSkzs9vWm4BmEqrEjbr+/iASevF5gIk4=";
    };
  };
}
