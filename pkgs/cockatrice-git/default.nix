{
  lib,
  generic-updater,
  fetchFromGitHub,
  stdenv,
  cmake,
  protobuf,
  kdePackages,
}: let
  rev' = "42cec1045725a29b72b1278ace7d037c5662f9d4";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "cockatrice";
    version = "2026-03-05-Development-2.11.0-beta.54-unstable-2026-03-09";

    src = fetchFromGitHub {
      owner = "Cockatrice";
      repo = "Cockatrice";
      rev = "${rev'}";
      sha256 = "sha256-3E2udfZ8T+M4x9S3513sxGDVBJzlGp4+av5amrOUcIQ=";
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
