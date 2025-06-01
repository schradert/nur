{
  flake.overlays.steam-rom-manager = final: _: {
    steam-rom-manager = final.callPackage ({
      lib,
      stdenv,
      buildPackages,
      fetchFromGitHub,
      fetchYarnDeps,
      fixup-yarn-lock,
      makeWrapper,
      pkg-config,
      xdg-utils,
      electron,
      nodejs,
      python3,
      sqlite,
      yarn,
      makeDesktopItem,
      copyDesktopItems,
    }:
      stdenv.mkDerivation rec {
        pname = "steam-rom-manager";
        version = lib.substring 0 7 src.rev;
        # TODO update steam-rom-manager to get fixes upstream
        src = fetchFromGitHub {
          owner = "schradert";
          repo = "steam-rom-manager";
          rev = "4d05174b0009c9f1ff92d475b290c165cfa629c5";
          hash = "sha256-z8x0G1kafPVEOFYKTK2PH+t65jqUnVwPa41AXMUiKg4=";
        };
        offlineCache = fetchYarnDeps {
          yarnLock = src + "/yarn.lock";
          hash = "sha256-UD2v3jIv41NrKygeHvVI9sWLFRifhIRgpDn1Ef3zhp0=";
        };
        nativeBuildInputs = [
          yarn
          nodejs
          (python3.withPackages (ps: [ps.setuptools]))
          fixup-yarn-lock
          pkg-config
          makeWrapper
          copyDesktopItems
        ];
        buildInputs = [sqlite xdg-utils];
        configurePhase = ''
          runHook preConfigure

          export HOME=$(mktemp -d)
          yarn config --offline set yarn-offline-mirror ${offlineCache}
          fixup-yarn-lock yarn.lock
          yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

          patchShebangs node_modules/

          # Rebuild better-sqlite3 with node-gyp
          mkdir -p "$HOME/.node-gyp/${nodejs.version}"
          echo 9 > "$HOME/.node-gyp/${nodejs.version}/installVersion"
          ln -sfv "${nodejs}/include" "$HOME/.node-gyp/${nodejs.version}"
          export npm_config_nodedir=${nodejs}
          npm_config_node_gyp="${buildPackages.nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js" npm rebuild --verbose --sqlite=${sqlite.dev} better-sqlite3

          runHook postConfigure
        '';
        buildPhase = ''
          runHook preBuild

          yarn config --offline set yarn-offline-mirror ${offlineCache}
          yarn --offline build:dist
          yarn --offline electron-builder --dir -c.electronDist=${electron.dist} -c.electronVersion=${electron.version}

          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall

          mkdir -p "$out/share/steam-rom-manager"
          cp -R ./release/*-unpacked/{locales,resources{,.pak}} "$out/share/steam-rom-manager"

          makeWrapper '${electron}/bin/electron' "$out/bin/steam-rom-manager" \
            --add-flags "$out/share/steam-rom-manager/resources/app.asar" \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
            --inherit-argv0

          runHook postInstall
        '';
        desktopItems = [
          (makeDesktopItem {
            name = "Steam ROM Manager";
            type = "Application";
            exec = "steam-rom-manager";
            icon = "steam-rom-manager";
            desktopName = "Steam ROM Manager";
            genericName = "Steam ROM Manager";
            categories = ["Game"];
          })
        ];
        meta.mainProgram = "steam-rom-manager";
      }) {};
  };
}
