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
    version = "0.10.0-Beta";
    src = fetchurl {
      url = "https://github.com/nikitabobko/AeroSpace/releases/download/v0.10.0-Beta/AeroSpace-v0.10.0-Beta.zip";
      sha256 = "sha256-7EOQzmxRJGKHymfOzbGZMwkgQet8qkAGT9lRGdzqgpw=";
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
    version = "v3.34.0";
    src = fetchFromGitHub {
      owner = "alist-org";
      repo = "alist";
      rev = "v3.34.0";
      fetchSubmodules = false;
      sha256 = "sha256-LHkUqOpZk8GZPUis+oX077w8LY7lLwrLu4AO/NvLVeg=";
    };
  };
  alist-web = {
    pname = "alist-web";
    version = "3.34.0";
    src = fetchurl {
      url = "https://github.com/alist-org/alist-web/releases/download/3.34.0/dist.tar.gz";
      sha256 = "sha256-gqY0wg34iwzjhdAp0KI6gEe4JSc2IdCMJ2Iy+zMJRCw=";
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
    version = "1196918e709f883eabfe3122ccad824b8f551381";
    src = fetchFromGitHub {
      owner = "nilaoda";
      repo = "BBDown";
      rev = "1196918e709f883eabfe3122ccad824b8f551381";
      fetchSubmodules = false;
      sha256 = "sha256-foTgCQKzYZc4aDxiAeoXR4jdEytqnkCt1Rwr2ztostM=";
    };
    date = "2023-11-13";
  };
  calibre = {
    pname = "calibre";
    version = "7.10.0";
    src = fetchurl {
      url = "https://download.calibre-ebook.com/7.10.0/calibre-7.10.0.dmg";
      sha256 = "sha256-djdLVnxY2U71b9xu1jIucm0FQ0UfvGdU7C4NnhFCFbQ=";
    };
  };
  calibrepath = {
    pname = "calibrepath";
    version = "7.10.0";
    src = fetchurl {
      url = "https://github.com/Cirn09/calibre-do-not-translate-my-path/releases/download/v7.10.0/mac-patch-backend+update-v7.10.0.zip";
      sha256 = "sha256-dXKe7ij8SreHpEXOK21r62iWiCNN/KV341m6gP3CeHQ=";
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
  "chrome.arm64" = {
    pname = "chrome.arm64";
    version = "124.0.6367.91";
    src = fetchurl {
      url = "https://registry.npmmirror.com/-/binary/chrome-for-testing/124.0.6367.91/mac-arm64/chrome-mac-arm64.zip";
      sha256 = "sha256-iv6PiW2TK6HLKi4A62Gr5G4JrbcvdmTmnsxR1qP+acE=";
    };
  };
  "chromium.arm64" = {
    pname = "chromium.arm64";
    version = "124.0.6367.91-1.1";
    src = fetchurl {
      url = "https://github.com/ungoogled-software/ungoogled-chromium-macos/releases/download/124.0.6367.91-1.1/ungoogled-chromium_124.0.6367.91-1.1_arm64-macos.dmg";
      sha256 = "sha256-nTfG9szAxPjiUPKblqCtGSesGKYxrADycQE6+krYstw=";
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
    version = "4.9.84";
    src = fetchurl {
      url = "https://github.com/darkreader/darkreader/releases/download/v4.9.84/darkreader-firefox.xpi";
      sha256 = "sha256-dmutarayoyczptfnRUaJLez82m8h5y/ykheSDXbETg8=";
    };
  };
  deeplx = {
    pname = "deeplx";
    version = "v0.9.4";
    src = fetchFromGitHub {
      owner = "OwO-Network";
      repo = "DeepLX";
      rev = "v0.9.4";
      fetchSubmodules = false;
      sha256 = "sha256-3kjDqPBOcyUSoionpA8a0n3LnAXU0tU5BVYnED2Sz/0=";
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
    version = "1.0.9";
    src = fetchurl {
      url = "https://github.com/yaobiao131/downkyicore/releases/download/v1.0.9/DownKyi-1.0.9-osx-arm64.dmg";
      sha256 = "sha256-/OyqHpFlZs2nA3xqjHLEOV2xrL9NlQtaa0oEIYGEfxI=";
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
    version = "61a1e971b228f416a95374cb8e5d95631fff3a42";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/61a1e971b228f416a95374cb8e5d95631fff3a42/patches/emacs-28/no-frame-refocus-cocoa.patch";
      sha256 = "sha256-+1d33IkKoHNJ8UOuZcK89D7a1v6/1WSwGiI1xaFfyr0=";
    };
    date = "2024-04-05";
  };
  "emacs29.poll" = {
    pname = "emacs29.poll";
    version = "61a1e971b228f416a95374cb8e5d95631fff3a42";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/61a1e971b228f416a95374cb8e5d95631fff3a42/patches/emacs-29/poll.patch";
      sha256 = "sha256-BS6srFt72GtGb5o9GL/5NX8rl1F/RjoJ5MUSVb2xRkg=";
    };
    date = "2024-04-05";
  };
  "emacs29.role-patch" = {
    pname = "emacs29.role-patch";
    version = "61a1e971b228f416a95374cb8e5d95631fff3a42";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/61a1e971b228f416a95374cb8e5d95631fff3a42/patches/emacs-28/fix-window-role.patch";
      sha256 = "sha256-H4Qj6n5uZsmsbdjjexGZctqhJk3gAXKiSnmnEO/LgTA=";
    };
    date = "2024-04-05";
  };
  "emacs29.round-undecorated-frame" = {
    pname = "emacs29.round-undecorated-frame";
    version = "61a1e971b228f416a95374cb8e5d95631fff3a42";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/61a1e971b228f416a95374cb8e5d95631fff3a42/patches/emacs-29/round-undecorated-frame.patch";
      sha256 = "sha256-dFH4D1WYQOVOagUuVdEQB3irxV+Y8dDAOKJOJXc/KHQ=";
    };
    date = "2024-04-05";
  };
  "emacs29.system-appearance" = {
    pname = "emacs29.system-appearance";
    version = "61a1e971b228f416a95374cb8e5d95631fff3a42";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/61a1e971b228f416a95374cb8e5d95631fff3a42/patches/emacs-28/system-appearance.patch";
      sha256 = "sha256-1u4VmDmzi2r1Ode5vf8jEmPkUcH9Qu7A0SUxjJ24zZI=";
    };
    date = "2024-04-05";
  };
  "emacs30.poll" = {
    pname = "emacs30.poll";
    version = "61a1e971b228f416a95374cb8e5d95631fff3a42";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/61a1e971b228f416a95374cb8e5d95631fff3a42/patches/emacs-30/poll.patch";
      sha256 = "sha256-Mbdtaigw+jttRT47v17HJZtbq/HZd7K/iKZiT6eMs+Y=";
    };
    date = "2024-04-05";
  };
  "emacs30.role-patch" = {
    pname = "emacs30.role-patch";
    version = "61a1e971b228f416a95374cb8e5d95631fff3a42";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/61a1e971b228f416a95374cb8e5d95631fff3a42/patches/emacs-28/fix-window-role.patch";
      sha256 = "sha256-H4Qj6n5uZsmsbdjjexGZctqhJk3gAXKiSnmnEO/LgTA=";
    };
    date = "2024-04-05";
  };
  "emacs30.round-undecorated-frame" = {
    pname = "emacs30.round-undecorated-frame";
    version = "61a1e971b228f416a95374cb8e5d95631fff3a42";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/61a1e971b228f416a95374cb8e5d95631fff3a42/patches/emacs-30/round-undecorated-frame.patch";
      sha256 = "sha256-dFH4D1WYQOVOagUuVdEQB3irxV+Y8dDAOKJOJXc/KHQ=";
    };
    date = "2024-04-05";
  };
  "emacs30.system-appearance" = {
    pname = "emacs30.system-appearance";
    version = "61a1e971b228f416a95374cb8e5d95631fff3a42";
    src = fetchurl {
      url = "https://github.com/d12frosted/homebrew-emacs-plus/raw/61a1e971b228f416a95374cb8e5d95631fff3a42/patches/emacs-30/system-appearance.patch";
      sha256 = "sha256-nrPOgGQAJb/5brrrWJNDARY2jWNJ9OsMtO+LPVhHfbY=";
    };
    date = "2024-04-05";
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
    version = "v0.2.14";
    src = fetchFromGitHub {
      owner = "kingwingfly";
      repo = "fav";
      rev = "v0.2.14";
      fetchSubmodules = false;
      sha256 = "sha256-lzTaaoA1pphPM6GHK2LgGE1quhhcFaTpJSAQq3rTN5c=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./fav-v0.2.14/Cargo.lock;
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
    version = "v4.3.3";
    src = fetchFromGitHub {
      owner = "go-musicfox";
      repo = "go-musicfox";
      rev = "v4.3.3";
      fetchSubmodules = false;
      sha256 = "sha256-J6R3T92cHFUkKwc+GKm612tVjglP2Tc/kDUmzUMhvio=";
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
  iina = {
    pname = "iina";
    version = "1.3.4";
    src = fetchurl {
      url = "https://github.com/iina/iina/releases/download/v1.3.4/IINA.v1.3.4.dmg";
      sha256 = "sha256-feUPWtSi/Vsnv1mjGyBgB0wFMxx6r6UzrUratlAo14w=";
    };
  };
  iinaplus = {
    pname = "iinaplus";
    version = "0.7.23";
    src = fetchurl {
      url = "https://github.com/xjbeta/iina-plus/releases/download/0.7.23/IINA+.0.7.23.dmg";
      sha256 = "sha256-Qf2GUNMwpvcVlMmeL3TGOvZB213fOXU8VNbAM+pY3Hc=";
    };
  };
  lazyvim-star = {
    pname = "lazyvim-star";
    version = "75625b29e8891938218043a7d619d67f79666a8d";
    src = fetchFromGitHub {
      owner = "LazyVim";
      repo = "starter";
      rev = "75625b29e8891938218043a7d619d67f79666a8d";
      fetchSubmodules = false;
      sha256 = "sha256-mZbQVDh6T3GylIPvMGFV9Sp4Oc6TMiqUYW8nPATs+dE=";
    };
    date = "2024-03-29";
  };
  localsend = {
    pname = "localsend";
    version = "1.14.0";
    src = fetchurl {
      url = "https://github.com/localsend/localsend/releases/download/v1.14.0/LocalSend-1.14.0.dmg";
      sha256 = "sha256-L7V48QoOA0cjx45n+9Xav/zzCzCsZB3TBip0WGusMXg=";
    };
  };
  lporg = {
    pname = "lporg";
    version = "v20.4.31";
    src = fetchFromGitHub {
      owner = "blacktop";
      repo = "lporg";
      rev = "v20.4.31";
      fetchSubmodules = false;
      sha256 = "sha256-A/OE67qAn9RHSCveiRwG5lPYNTMdrbUWVfQOP3XjkdU=";
    };
  };
  lyricx = {
    pname = "lyricx";
    version = "1.6.4";
    src = fetchurl {
      url = "https://github.com/go-musicfox/LyricsX/releases/download/v1.6.4/LyricsX_1.6.4.zip";
      sha256 = "sha256-xEj0jin2aLQlOcPVITmL14ZVLGKAm1wZf8f4FuLmVB0=";
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
  mihomo = {
    pname = "mihomo";
    version = "v1.18.4";
    src = fetchFromGitHub {
      owner = "MetaCubeX";
      repo = "mihomo";
      rev = "v1.18.4";
      fetchSubmodules = false;
      sha256 = "sha256-mqNcMB2nb8+e9XEGKqwaBE/nC4+jRaEFxE17e0JTo8Y=";
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
    version = "0.12.2";
    src = fetchurl {
      url = "https://github.com/neovide/neovide/releases/download/0.12.2/neovide.dmg.zip";
      sha256 = "sha256-cCLswmyKXMwG0RTJWMFFcgdfWyaU9saTgrsZwJuFA1A=";
    };
  };
  next-chat = {
    pname = "next-chat";
    version = "2.12.2";
    src = fetchurl {
      url = "https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web/releases/download/v2.12.2/NextChat_2.12.2_universal.dmg";
      sha256 = "sha256-VKV5Sqeb5zUW75Pr2hvT2X3bLQYlrqXh0DHNxzxZ7CU=";
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
    version = "release-4.6.4.10";
    src = fetchFromGitHub {
      owner = "c0re100";
      repo = "qBittorrent-Enhanced-Edition";
      rev = "release-4.6.4.10";
      fetchSubmodules = false;
      sha256 = "sha256-wrkc11H4t96D6qr9N/2CzG93zeNv7I1g9ieXyc4x5wk=";
    };
  };
  qutebrowser = {
    pname = "qutebrowser";
    version = "3.1.0";
    src = fetchurl {
      url = "https://github.com/qutebrowser/qutebrowser/releases/download/v3.1.0/qutebrowser-3.1.0.dmg";
      sha256 = "sha256-AvuuwUnxMcr2ekZ/O1FL/4IizV1aTMhXNrbf1SwNY7U=";
    };
  };
  ryujinx = {
    pname = "ryujinx";
    version = "1.1.1297";
    src = fetchurl {
      url = "https://github.com/Ryujinx/release-channel-master/releases/download/1.1.1297/ryujinx-1.1.1297-macos_universal.app.tar.gz";
      sha256 = "sha256-QIv1bvH/xkh2tnQEEPxajerIVHI7q7JJ24mbczEnLvk=";
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
    version = "v0.1.0.1";
    src = fetchFromGitHub {
      owner = "shanyouli";
      repo = "sd";
      rev = "v0.1.0.1";
      fetchSubmodules = false;
      sha256 = "sha256-9rHZt744sLkr2rkR6NZGpWJ4aZxRr54Feqt2Kt7NnfQ=";
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
    version = "3.6.0";
    src = fetchurl {
      url = "https://github.com/KRTirtho/spotube/releases/download/v3.6.0/Spotube-macos-universal.dmg";
      sha256 = "sha256-Qsr+66ToyLCCUwirj/7V6vzSNmx7BZ3O34liLx6AdlI=";
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
  vivaldi = {
    pname = "vivaldi";
    version = "6.7.3329.24";
    src = fetchurl {
      url = "https://downloads.vivaldi.com/stable/Vivaldi.6.7.3329.24.universal.dmg";
      sha256 = "sha256-eB0vPJcrb52W7kT8vQuD6MboACqabfxH4jcs4uimatw=";
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
    version = "v7.1.0";
    src = fetchFromGitHub {
      owner = "koekeishiya";
      repo = "yabai";
      rev = "v7.1.0";
      fetchSubmodules = false;
      sha256 = "sha256-5iC1U6tyUYFLjOfnIxCrjCjj2deUZ/rvsJN4jlrr2Tc=";
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
  yutto = {
    pname = "yutto";
    version = "v2.0.0-beta.37";
    src = fetchFromGitHub {
      owner = "yutto-dev";
      repo = "yutto";
      rev = "v2.0.0-beta.37";
      fetchSubmodules = false;
      sha256 = "sha256-daRuFYfR3FjvhVsQM1FXI19iOH+bukh6WxfH5O+CFk4=";
    };
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
    version = "3.3.4";
    src = fetchurl {
      url = "https://github.com/Hiram-Wong/ZyPlayer/releases/download/v3.3.4/zyplayer-mac-3.3.4-arm64.dmg";
      sha256 = "sha256-bxgEKJiNKxV80HwJJam7NSgVGfy4FUtG9SNL/E69mgk=";
    };
  };
}
