{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  protobuf,
  kdePackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cockatrice";
  version = "fe7853a3896b9bbe021085264f0f0fdfa9fd07f7";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = finalAttrs.version;
    sha256 = "sha256-kKHoNtqnmoByS3e5Qeq76e/ARUlv7w4BgOGp9AWCt7E=";
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
