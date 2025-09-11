{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  protobuf,
  kdePackages,
}: let
  rev' = "216cd491cceb26936652bba9d57a57513cc664e9";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "cockatrice";
    version = "2025-09-10-Development-2.11.0-beta.26-unstable-2025-09-11";

    src = fetchFromGitHub {
      owner = "Cockatrice";
      repo = "Cockatrice";
      rev = "${rev'}";
      sha256 = "sha256-aGkPixIXLD1drzD+fO+Bya1Bd1tCfvCCR5xMQC5iEJY=";
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
      maintainers = with lib.maintainers; [evanjs];
      platforms = with lib.platforms; linux;
    };
  })
