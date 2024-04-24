# {pkgs ? import <nixpkgs> {}}:
# with pkgs;
# with pkgs.lib;
{
  lib,
  makeWrapper,
  yarn,
  stdenv,
  prefetch-yarn-deps,
  nodejs,
  desktopToDarwinBundle,
  fetchFromGitHub,
  fetchYarnDeps,
  makeDesktopItem,
  tree,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zyplayer";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "Hiram-Wong";
    repo = "ZyPlayer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AwNdh4SCkaMrv+ztxC68IOv87bFhZmMUE+CWoh6y8dg=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    sha256 = "sha256-DVlo0cMshyBY5ar0KtFIGw5a/G5P9d5eG7BfMZ6JVIA=";
  };

  nativeBuildInputs =
    [makeWrapper yarn prefetch-yarn-deps nodejs tree] ++ lib.optionals stdenv.isDarwin [desktopToDarwinBundle];
  # ++ lib.optionals (!stdenv.isDarwin) [copyDesktopItems];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  # Only affects unused scripts in $out/share/element/electron/scripts. Also
  # breaks because there are some `node`-scripts with a `npx`-shebang and
  # this shouldn't be in the closure just for unused scripts.
  dontPatchShebangs = true;
  buildPhase = ''
    runHook preBuild
    yarn --offline run build:web
    runHook postBuild
  '';
  # installPhase = let
  #   libPath = lib.makeLibraryPath [
  #     libnotify
  #   ];
  # in
  installPhase = ''
    runHook preInstall

    # resources
    tree

    runHook postInstall
  '';
  # mkdir -p "$out/share/element"
  # ln -s '${element-web}' "$out/share/element/webapp"
  # cp -r '.' "$out/share/element/electron"
  # cp -r './res/img' "$out/share/element"
  # rm -rf "$out/share/element/electron/node_modules"
  # cp -r './node_modules' "$out/share/element/electron"
  # cp $out/share/element/electron/lib/i18n/strings/en_EN.json $out/share/element/electron/lib/i18n/strings/en-us.json
  # ln -s $out/share/element/electron/lib/i18n/strings/en{-us,}.json

  # # icons
  # for icon in $out/share/element/electron/build/icons/*.png; do
  #   mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
  #   ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/element.png"
  # done

  # # desktop item
  # mkdir -p "$out/share"
  # ln -s "${finalAttrs.desktopItem}/share/applications" "$out/share/applications"

  # # executable wrapper
  # # LD_PRELOAD workaround for sqlcipher not found: https://github.com/matrix-org/seshat/issues/102
  # makeWrapper '${electron}/bin/electron' "$out/bin/${executableName}" \
  #   --add-flags "$out/share/element/electron" \
  #   --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

  # The desktop item properties should be kept in sync with data from upstream:
  # https://github.com/vector-im/element-desktop/blob/develop/package.json
  desktopItem = makeDesktopItem {
    name = "${finalAttrs.pname}";
    exec = "${finalAttrs.pname} %u";
    icon = "${finalAttrs.pname}";
    desktopName = "ZyPlayer";
    startupWMClass = "ZyPlayer";
    categories = ["AudioVideo"];
    genericName = "ZyPlayer";
    # comment = finalAttrs.meta.description;
  };

  postFixup = lib.optionalString stdenv.isDarwin ''
    cp build/icon.icns $out/Applications/Element.app/Contents/Resources/element.icns
  '';

  # meta = with lib; {
  #   description = "A feature-rich client for Matrix.org";
  #   homepage = "https://element.io/";
  #   changelog = "https://github.com/vector-im/element-desktop/blob/v${finalAttrs.version}/CHANGELOG.md";
  #   license = licenses.asl20;
  #   maintainers = teams.matrix.members;
  #   inherit (electron.meta) platforms;
  #   mainProgram = "element-desktop";
  # };

  meta = with lib; {
    # description = "Electron wrapper around YouTube Music";
    # homepage = "https://th-ch.github.io/youtube-music/";
    # license = licenses.mit;
    # maintainers = [ maintainers.aacebedo ];
    mainProgram = "${finalAttrs.pname}";
    platforms = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
  };
})
