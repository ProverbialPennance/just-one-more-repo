{
  lib,
  generic-updater,
  fetchFromGitHub,
  stdenv,
  cmake,
  protobuf,
  kdePackages,
}: let
  rev' = "12299abcc87d829ce53635089d9ff0956aaa09f1";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "cockatrice";
    version = "2026-09-18-Development-3.1.0-beta.12-unstable-2026-09-20";

    src = fetchFromGitHub {
      owner = "Cockatrice";
      repo = "Cockatrice";
      rev = "${rev'}";
      sha256 = "sha256-oW6swcEfv8UpZp7uUhQqZFJF6FKnqldhlIoYXwnajOw=";
    };

    passthru.updateScript = generic-updater {
      extraArgs = ["--version=branch"];
    };

    buildInputs = [
      kdePackages.qtbase
      kdePackages.qtmultimedia
      protobuf
      kdePackages.qttools
      kdePackages.qtwebsockets
    ];

    nativeBuildInputs = [
      cmake
      kdePackages.wrapQtAppsHook
    ];

    meta = {
      homepage = "https://github.com/Cockatrice/Cockatrice";
      description = "Cross-platform virtual tabletop for multiplayer card games";
      license = lib.licenses.gpl2Plus;
      # maintainers = with lib.maintainers; [evanjs];
      platforms = with lib.platforms; linux;
    };
  })
