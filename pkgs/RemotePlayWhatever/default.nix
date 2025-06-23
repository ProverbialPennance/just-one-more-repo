{
  lib,
  fetchFromGitHub,
  stdenv,
  fetchurl,
  cmake,
  git,
  wxGTK32,
  imagemagick,
  makeDesktopItem,
}: let
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/m4dEngi/RemotePlayWhatever/refs/heads/master/RemotePlayWhatever/appicon.ico";
    hash = "sha256-xFkSMtRudczaDXMkJNL3HwkyrvRJE6dpRZPDULXdUSg=";
  };
in
  stdenv.mkDerivation (finalAtrrs: {
    pname = "RemotePlayWhatever";
    version = "0.2.10-alpha";

    src = fetchFromGitHub {
      owner = "m4dEngi";
      repo = "RemotePlayWhatever";
      tag = "${finalAtrrs.version}";
      hash = "sha256-SHYjZZNUofEynOy50Kd+caJ2sQ7zTDZ4SDjlUCuPaNM=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      cmake
      git
      imagemagick
    ];

    buildInputs = [
      wxGTK32
    ];

    enableParallelBuilding = true;

    makeFlags = [];

    patches = [./un-debian.patch];

    desktopItems = makeDesktopItem {
      name = "RemotePlayWhatever";
      icon = "RemotePlayWhatever";
      exec = "remoteplaywhatever";
      comment = finalAtrrs.meta.description;
      desktopName = "RemotePlayWhatever";
      categories = ["Game" "Network"];
    };

    postInstall = ''
      mkdir -p $out/share/pixmaps
      magick ${icon} -background none -virtual-pixel none \
      \( -clone 0--1 +repage -layers merge \) \
      -distort affine "0,0 0,%[fx:s.w==u[-1].w&&s.h==u[-1].h?0:h]" \
      -delete -1 -layers merge $out/share/pixmaps/${finalAtrrs.pname}.png
      for i in 16 24 48 64 96 128 256 512; do
        mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
        magick $out/share/pixmaps/${finalAtrrs.pname}.png -background none -resize ''${i}x''${i}  $out/share/icons/hicolor/''${i}x''${i}/apps/${finalAtrrs.pname}.png
        done
      mkdir -p $out/share/applications
      cp ${finalAtrrs.desktopItems}/share/applications/*.desktop $out/share/applications/
    '';

    meta = {
      description = "Force remote play together any game you have in your steam library including non-steam ones.";
      longDescription = ''
        Tiny application that lets you force remote play together any game you have in your steam library including non-steam ones.

        RemotePlayWhatever communicates with your running Steam client and instructs it to initiate a Remote Play Together session for the currently running game launched through Steam.
        It does this by using undocumented and potentially unstable internal Steam client APIs.
      '';
      license = lib.licenses.mit;
      platforms = lib.platforms.x86;
      mainProgram = "remoteplaywhatever";
      homepage = "https://github.com/m4dEngi/RemotePlayWhatever";
      changelog = "https://github.com/m4dEngi/RemotePlayWhatever/releases/tag/${finalAtrrs.version}";
    };
  })
