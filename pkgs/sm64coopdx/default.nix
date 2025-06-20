{
  lib,
  fetchFromGitHub,
  makeWrapper,
  curl,
  hexdump,
  python3,
  SDL2,
  stdenv,
  zlib,
  libGL,
  imagemagick,
  makeDesktopItem,
  enableCoopNet ? true,
  enableDiscord ? true,
  enableTextureFix ? true,
  enhanceLevelTextures ? true,
  handHeld ? false,
}:
stdenv.mkDerivation (finalAtrrs: {
  pname = "sm64coopdx";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "coop-deluxe";
    repo = "sm64coopdx";
    tag = "v${finalAtrrs.version}";
    hash = "sha256-I/Rk8oLc/CP9izK7E2OnL8Afmc6/rqVqzWGqSENvqcs=";
  };

  nativeBuildInputs = [
    makeWrapper
    imagemagick # icon extraction and image conversion
  ];

  buildInputs = [
    curl
    hexdump
    python3
    SDL2
    zlib
    libGL
  ];

  enableParallelBuilding = true;

  makeFlags =
    [
      "BREW_PREFIX=/not-exist"
      "COOPNET=${
        if enableCoopNet
        then "1"
        else "0"
      }"
      "DISCORD_SDK=${
        if enableDiscord
        then "1"
        else "0"
      }"
      "TEXTURE_FIX=${
        if enableTextureFix
        then "1"
        else "0"
      }"
      "ENHANCE_LEVEL_TEXTURES=${
        if enhanceLevelTextures
        then "1"
        else "0"
      }"
      "HANDHELD=${
        if handHeld
        then "1"
        else "0"
      }"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "OSX_BUILD=1"
    ];

  preBuild = ''
    # remove -march flags, stdenv manages them
    substituteInPlace Makefile \
      --replace-fail ' -march=$(TARGET_ARCH)' ""
  '';

  installPhase = ''
    runHook preInstall

    local built=$PWD/build/us_pc
    local share=$out/share/sm64coopdx
    mkdir -p $share
    cp $built/sm64coopdx $share/sm64coopdx
    cp -r $built/{dynos,lang,mods,palettes} $share

    ${lib.optionalString enableDiscord ''
      cp $built/libdiscord_game_sdk* $share
    ''}

    # coopdx always tries to load resources from the binary's directory, with no obvious way to change. Thus this small wrapper script to always run from the /share directory that has all the resources
    mkdir -p $out/bin
    makeWrapper $share/sm64coopdx $out/bin/sm64coopdx \
      --chdir $share

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/share/pixmaps
    magick ./res/icon.ico -background none -virtual-pixel none \
    \( -clone 0--1 +repage -layers merge \) \
    -distort affine "0,0 0,%[fx:s.w==u[-1].w&&s.h==u[-1].h?0:h]" \
    -delete -1 -layers merge $out/share/pixmaps/${finalAtrrs.pname}.png
    # magick ./res/icon.ico -flatten -alpha on -background none -flatten $out/share/pixmaps/${finalAtrrs.pname}.png
    for i in 16 24 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      magick $out/share/pixmaps/${finalAtrrs.pname}.png -background none -resize ''${i}x''${i}  $out/share/icons/hicolor/''${i}x''${i}/apps/${finalAtrrs.pname}.png
      done
    install -Dm644 ./textures/segment2/custom_coopdx_logo.rgba32.png $out/share/pixmaps/sm64coopdx.png
    mkdir -p $out/share/applications
    cp ${finalAtrrs.desktopItems}/share/applications/*.desktop $out/share/applications/
  '';

  desktopItems = makeDesktopItem {
    name = "sm64coopdx";
    icon = "sm64coopdx";
    exec = "sm64coopdx";
    comment = finalAtrrs.meta.description;
    desktopName = "sm64coopdx";
    categories = ["Game"];
  };

  meta = {
    description = "Multiplayer fork of the Super Mario 64 decompilation";
    longDescription = ''
      This is a fork of sm64ex-coop, which was itself a fork of sm64ex, which was a fork of the sm64 decompilation project.

      It allows multiple people to play within and across levels, has multiple character models, and mods in the form of lua scripts.

      Arguments:

      - `enableTextureFix`: (default: `true`) whether to enable texture fixes. Upstream describes disabling this as "for purists"
      - `enableDiscord`: (default: `true`) whether to enable discord integration, which allows showing status and connecting to games over discord
      - `enableCoopNet`: (default: `true`) whether to enable Co-op Net integration, a server made specifically for multiplayer sm64
      - `enhanceLevelTextures`: (default: `true`) whether to enable further modability of level textures. Without, certaines textures have forced hues
      - `handheld`: (default: `false`) whether to "Make some small adjustments for handheld devices" as per upstream's description
    '';
    license = lib.licenses.unfree;
    platforms = lib.platforms.x86;
    # maintainers = [ lib.maintainers.shelvacu ];
    mainProgram = "sm64coopdx";
    homepage = "https://sm64coopdx.com/";
    changelog = "https://github.com/coop-deluxe/sm64coopdx/releases/tag/v${finalAtrrs.version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # The lua engine, discord sdk, and coopnet library are vendored pre-built. See https://github.com/coop-deluxe/sm64coopdx/tree/v1.0.3/lib
      binaryNativeCode
    ];
  };
})
