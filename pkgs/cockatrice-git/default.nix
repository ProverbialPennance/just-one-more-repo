{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  protobuf,
  kdePackages,
}: let
  rev' = "a8ee0d76481a7ddcf8ede051c1e925e29a33fc8c";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "cockatrice";
    version = "2025-11-16-Development-2.11.0-beta.36-unstable-2025-11-17";

    src = fetchFromGitHub {
      owner = "Cockatrice";
      repo = "Cockatrice";
      rev = "${rev'}";
      sha256 = "sha256-6d6uTRPoZgERTimiHYvLAgX15cq1BFwA/TQt64tngtU=";
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
