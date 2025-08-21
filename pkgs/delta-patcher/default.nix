{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  cmake,
  pkg-config,
  gtk3,
  wxwidgets_3_3,
  xdelta,
  xz,
}: let
  tag = "3.1.5-build-fix";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "delta-patcher";
    version = "${tag}";

    src = fetchFromGitHub {
      owner = "marco-calautti";
      repo = "DeltaPatcher";
      tag = "v${tag}";
      hash = "sha256-NvxkffQcSM/RbwGaDSQbeXu2BplSTdbF7w9lLyV7Yzg=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      cmake
      pkg-config
      copyDesktopItems
    ];

    buildInputs = [
      gtk3
      wxwidgets_3_3
      xdelta
      xz
    ];

    postInstall = ''
      install -Dm644 ../graphics/icon256.png $out/share/pixmaps/DeltaPatcher.png
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "DeltaPatcher";
        icon = "DeltaPatcher";
        exec = "DeltaPatcher";
        comment = finalAttrs.meta.description;
        genericName = "Delta Patcher";
        desktopName = "DeltaPatcher";
        categories = ["Utility"];
      })
    ];

    meta = {
      homepage = "https://github.com/marco-calautti/DeltaPatcher";
      description = "Delta Patcher is a GUI software that is able to create and apply xdelta patches.";
      mainProgram = "DeltaPatcher";
      platforms = ["x86_64-linux"];
      maintainers = [];
      license = with lib.licenses; [
        gpl2
      ];
    };
  })
