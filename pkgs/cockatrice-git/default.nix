{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  protobuf,
  kdePackages,
}: let
  rev' = "fb23cc8c7a3ca97dcbd865901cfbc69e4d54b872";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "cockatrice";
    version = "2025-09-12-Development-2.11.0-beta.28-unstable-2025-09-12";

    src = fetchFromGitHub {
      owner = "Cockatrice";
      repo = "Cockatrice";
      rev = "${rev'}";
      sha256 = "sha256-h8fP2LPKA+0tI413UGSSzvHYbbyViqZDZ2cr5lfd97c=";
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
