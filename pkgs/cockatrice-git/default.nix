{
  lib,
  generic-updater,
  fetchFromGitHub,
  stdenv,
  cmake,
  protobuf,
  kdePackages,
}: let
  rev' = "5ea16c805f8c4ace3b59c47d19658f13032eea29";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "cockatrice";
    version = "2026-11-03-Development-3.2.0-beta-unstable-2026-11-04";

    src = fetchFromGitHub {
      owner = "Cockatrice";
      repo = "Cockatrice";
      rev = "${rev'}";
      sha256 = "sha256-BW4wL9BHAB3LJU7bfvMZ3cIB3rGsEp6f9O0mr5rpIjw=";
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
