{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoPatchelfHook,
  python3,
  pkg-config,
  git,
  openssl,
  cmake,
  jsoncpp,
  audiofile,
  SDL2,
  libGL,
  hexdump,
  zlib,
  sm64baserom,
  region ? "us",
  _60fps ? true,
  moveset ? true,
  nonstop ? true,
}: let
  baseRom = (sm64baserom.override {inherit region;}).romPath;
in
  gcc15Stdenv.mkDerivation (finalAttrs: {
    pname = "sm64ex-ap";
    version = "0-unstable-2025-06-01";

    src = fetchFromGitHub {
      owner = "N00byKing";
      repo = "sm64ex";
      rev = "0e88a60f94535ef9653e9c66c53d3178d131e5e0";
      hash = "sha256-YZyekQj1q2idpLJXVcz+4FrD6iaPmPH+hYJsolwt9PI=";

      leaveDotGit = true;
      deepClone = true;
      fetchSubmodules = true;
      forceFetchGit = true;
    };

    patches =
      lib.optionals
      _60fps
      [
        (fetchpatch {
          name = "60fps_ex.patch";
          url = "file://${finalAttrs.src}/enhancements/60fps_ex.patch";
          hash = "sha256-2V7WcZ8zG8Ef0bHmXVz2iaR48XRRDjTvynC4RPxMkcA=";
        })
      ]
      ++ lib.optionals
      moveset
      [
        (fetchpatch {
          name = "Extended.Moveset.v1.03b.sm64ex_archipelago.patch";
          url = "file://${finalAttrs.src}/enhancements/Extended.Moveset.v1.03b.sm64ex_archipelago.patch";
          hash = "sha256-kvsVZu5sXRJpya2BcnJOA+sgORBL3jK6YiZf/Gt3LlA=";
        })
      ]
      ++ lib.optionals
      nonstop
      [
        (fetchpatch {
          name = "nonstop_mode_always_enabled.patch";
          url = "file://${finalAttrs.src}/enhancements/nonstop_mode_always_enabled.patch";
          hash = "sha256-s9V8UeIcjNyczfNPmgawgCmKJUkdCItSEr1cQ3ZyX/Q=";
        })
      ];

    nativeBuildInputs = [
      autoPatchelfHook
      python3
      pkg-config
      hexdump
      git
      cmake
      openssl.dev
    ];

    buildInputs = [
      audiofile
      SDL2
      libGL
      zlib
      jsoncpp
    ];

    enableParallelBuilding = true;
    dontUseCmakeConfigure = true;

    makeFlags =
      [
        "VERSION=${region}"
        "BETTERCAMERA=1"
        "TEXTURE_FIX=1"
        "DISCORDRPC=1"
      ]
      ++ lib.optionals gcc15Stdenv.hostPlatform.isDarwin [
        "OSX_BUILD=1"
      ];

    preConfigure = ''
      echo $out
    '';

    preBuild = ''
      patchShebangs extract_assets.py
      ln -s ${baseRom} ./baserom.${region}.z64
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp build/${region}_pc/sm64.${region}.f3dex2e $out/bin/sm64ex-ap
      cp build/${region}_pc/libAPCpp.so $out/bin/libAPCpp.so

      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/N00byKing/sm64ex";
      description = "Fork of https://github.com/sm64-port/sm64-port with additional features.";
      mainProgram = "sm64ex-ap";
      license = lib.licenses.unfree;
      maintainers = [];
      platforms = lib.platforms.unix;
    };
  })
