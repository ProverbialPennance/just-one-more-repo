{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  protobuf,
  kdePackages,
}: let
  rev' = "94ba1c83c6f5b74cd1dd78f8d270351d85ac2ae2";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "cockatrice";
    version = "2025-09-13-Development-2.11.0-beta.29-unstable-2025-09-15";

    src = fetchFromGitHub {
      owner = "Cockatrice";
      repo = "Cockatrice";
      rev = "${rev'}";
      sha256 = "sha256-DnE4D+kZL3T3Dl24yF+Uq8v2nLdN+pZ+gY4+mp2iYNA=";
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
