{
  lib,
  kdePackages,
  cmake,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
}: let
  tag = "1.3.0-preview2";
in
  stdenv.mkDerivation (
    finalAttrs: {
      pname = "dolphin-memory-engine";
      version = "${tag}";

      src = fetchFromGitHub {
        owner = "aldelaro5";
        repo = "dolphin-memory-engine";
        tag = "${tag}";
        hash = "sha256-VjxeD/PSyGtvArA1DTIPxm0uOHwfRLh7cbZFcstM1Is=";
        fetchSubmodules = true;
        deepClone = true;
        postFetch = ''
          cd $out
          git branch --show-current > GIT_BRANCH
          git rev-parse --short=7 HEAD > GIT_COMMIT_HASH
          (git describe --exact-match --tags HEAD 2>/dev/null || echo "") > GIT_COMMIT_TAG
          rm -rf .git
        '';
      };

      nativeBuildInputs = [
        cmake
        kdePackages.wrapQtAppsHook
        copyDesktopItems
      ];

      buildInputs = [
        kdePackages.qtbase
        kdePackages.qtsvg
      ];

      preConfigure = ''
        cd Source
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp dolphin-memory-engine $out/bin
        runHook postInstall
      '';

      postInstall = ''
        install -Dm644 ../Resources/logo.svg $out/share/pixmaps/dolphin-memory-engine.svg
      '';

      desktopItems = [
        (makeDesktopItem {
          name = "dolphin-memory-engine";
          icon = "dolphin-memory-engine";
          exec = "dolphin-memory-engine";
          comment = finalAttrs.meta.description;
          genericName = "dolphin-memory-engine";
          desktopName = "dolphin-memory-engine";
          categories = ["Development" "Utility"];
        })
      ];

      meta = {
        homepage = "https://github.com/aldelaro5/dolphin-memory-engine";
        description = "A RAM search made specifically to search, monitor and edit the Dolphin emulator's emulated memory";
        mainProgram = "dolphin-memory-engine";
        platforms = lib.platforms.linux;
        maintainers = [];
        license = with lib.licenses; [mit];
      };
    }
  )
