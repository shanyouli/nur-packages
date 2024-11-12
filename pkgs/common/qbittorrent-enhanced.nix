{
  lib,
  stdenv,
  sources,
  boost,
  cmake,
  apple-sdk,
  libtorrent-rasterbar,
  ninja,
  qt6Packages,
  wrapGAppsHook,
  guiSupport ? true,
  dbus,
  trackerSearch ? true,
  python3,
  webuiSupport ? true,
}: let
  inherit (qt6Packages) qtbase qtsvg qttools qtwayland wrapQtAppsHook;
  qtVersion = lib.versions.major qtbase.version;
in
  stdenv.mkDerivation rec {
    inherit (sources.qbittorrent) src version;
    pname =
      "qbittorrent-enhanced"
      + lib.optionalString (guiSupport && qtVersion == "5") "-qt5"
      + lib.optionalString (!guiSupport) "-nox";

    nativeBuildInputs = [
      cmake
      ninja
      wrapGAppsHook
      wrapQtAppsHook
    ];

    buildInputs =
      [
        boost
        libtorrent-rasterbar
        qtbase
        qtsvg
        qttools
      ]
      ++ lib.optionals stdenv.isDarwin [apple-sdk]
      ++ lib.optionals guiSupport [dbus]
      ++ lib.optionals (guiSupport && stdenv.isLinux) [
        qtwayland
      ]
      ++ lib.optionals trackerSearch [
        python3
      ];

    cmakeFlags =
      lib.optionals (qtVersion == "6") [
        "-DQT6=ON"
      ]
      ++ lib.optionals (!guiSupport) [
        "-DGUI=OFF"
        "-DSYSTEMD=ON"
        "-DSYSTEMD_SERVICES_INSTALL_DIR=${placeholder "out"}/lib/systemd/system"
      ]
      ++ lib.optionals (!webuiSupport) [
        "-DWEBUI=OFF"
      ]
      ++ ["-DCMAKE_CXX_FLAGS=-Wno-c++20-extensions"];

    qtWrapperArgs = lib.optionals trackerSearch [
      "--prefix PATH : ${lib.makeBinPath [python3]}"
    ];

    dontWrapGApps = true;

    postInstall = lib.optionalString stdenv.isDarwin ''
      APP_NAME=qbittorrent${lib.optionalString (!guiSupport) "-nox"}
      mkdir -p $out/{Applications,bin}
      cp -R $APP_NAME.app $out/Applications
      makeWrapper $out/{Applications/$APP_NAME.app/Contents/MacOS,bin}/$APP_NAME
    '';

    preFixup = ''
      qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
    '';

    meta = with lib; {
      description = "Featureful free software BitTorrent client";
      homepage = "https://www.qbittorrent.org";
      changelog = "https://github.com/qbittorrent/qBittorrent/blob/release-${version}/Changelog";
      license = licenses.gpl2Plus;
      platforms = platforms.unix;
      maintainers = with maintainers; [Anton-Latukha kashw2];
    };
  }
