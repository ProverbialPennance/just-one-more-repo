{
  lib,
  generic-updater,
  fetchFromGitHub,
  stdenv,
  cmake,
  protobuf,
  kdePackages,
}: let
  rev' = "2914874720ebb697c57bcd5dd23485d6d7ec0555";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "cockatrice";
    version = "2026-06-26-Release-3.0.2-unstable-2026-06-27";

    src = fetchFromGitHub {
      owner = "Cockatrice";
      repo = "Cockatrice";
      rev = "${rev'}";
      sha256 = "sha256-Q+74xnDZBIiSZ129LV5m4ytLwA/Gxj6wrvaozvO7QFM=";
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
