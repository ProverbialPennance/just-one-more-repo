{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  protobuf,
  kdePackages,
}: let
  rev' = "ba794c2b600565edd541a996b8e373d5d57441c6";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "cockatrice";
    version = "2025-08-16-Development-2.11.0-beta.24-unstable-2025-08-24";

    src = fetchFromGitHub {
      owner = "Cockatrice";
      repo = "Cockatrice";
      rev = "${rev'}";
      sha256 = "sha256-T90HKIxawULnclL8azU3NMbM20skmVumA8xrW2GOIcs=";
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
