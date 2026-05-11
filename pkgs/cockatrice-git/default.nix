{
  lib,
  generic-updater,
  fetchFromGitHub,
  stdenv,
  cmake,
  protobuf,
  kdePackages,
}: let
  rev' = "1a62f82aeed2086210c194442988b4e6e021f552";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "cockatrice";
    version = "2026-05-08-Release-3.0.0-unstable-2026-05-11";

    src = fetchFromGitHub {
      owner = "Cockatrice";
      repo = "Cockatrice";
      rev = "${rev'}";
      sha256 = "sha256-/nkDYRgnQaMpNkfY79BNHCDmKlMTv5aSoOpsUuqELI8=";
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
