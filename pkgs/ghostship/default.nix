{
  lib,
  fetchFromGitHub,
  applyPatches,
  writeTextFile,
  fetchurl,
  stdenv,
  generic-updater,
  replaceVars,
  yaml-cpp,
  srcOnly,
  cmake,
  copyDesktopItems,
  installShellFiles,
  lsb-release,
  makeWrapper,
  ninja,
  pkg-config,
  libGL,
  libvorbis,
  libX11,
  libzip,
  nlohmann_json,
  SDL2,
  sdl_gamecontrollerdb,
  spdlog,
  tinyxml-2,
  zenity,
  ghostship,
  makeDesktopItem,
  withDebug ? true,
}: let
  # The following are either normally fetched during build time or a specific version is required
  dr_libs = fetchFromGitHub {
    owner = "mackron";
    repo = "dr_libs";
    rev = "da35f9d6c7374a95353fd1df1d394d44ab66cf01";
    hash = "sha256-ydFhQ8LTYDBnRTuETtfWwIHZpRciWfqGsZC6SuViEn0=";
  };

  imgui' = applyPatches {
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      tag = "v1.91.9b-docking";
      hash = "sha256-mQOJ6jCN+7VopgZ61yzaCnt4R1QLrW7+47xxMhFRHLQ=";
    };
    patches = [
      "${ghostship.src}/libultraship/cmake/dependencies/patches/imgui-fixes-and-config.patch"
    ];
  };

  libgfxd = fetchFromGitHub {
    owner = "glankk";
    repo = "libgfxd";
    rev = "008f73dca8ebc9151b205959b17773a19c5bd0da";
    hash = "sha256-AmHAa3/cQdh7KAMFOtz5TQpcM6FqO9SppmDpKPTjTt8=";
  };

  prism = fetchFromGitHub {
    owner = "KiritoDv";
    repo = "prism-processor";
    rev = "bbcbc7e3f890a5806b579361e7aa0336acd547e7";
    hash = "sha256-jRPwO1Vub0cH12YMlME6kd8zGzKmcfIrIJZYpQJeOks=";
  };

  stb_impl = writeTextFile {
    name = "stb_impl.c";
    text = ''
      #define STB_IMAGE_IMPLEMENTATION
      #include "stb_image.h"
    '';
  };

  stb' = fetchurl {
    name = "stb_image.h";
    url = "https://raw.githubusercontent.com/nothings/stb/0bc88af4de5fb022db643c2d8e549a0927749354/stb_image.h";
    hash = "sha256-xUsVponmofMsdeLsI6+kQuPg436JS3PBl00IZ5sg3Vw=";
  };

  stormlib' = applyPatches {
    src = fetchFromGitHub {
      owner = "ladislav-zezula";
      repo = "StormLib";
      tag = "v9.25";
      hash = "sha256-HTi2FKzKCbRaP13XERUmHkJgw8IfKaRJvsK3+YxFFdc=";
    };
    patches = [
      "${ghostship.src}/libultraship/cmake/dependencies/patches/stormlib-optimizations.patch"
    ];
  };

  thread_pool = fetchFromGitHub {
    owner = "bshoshany";
    repo = "thread-pool";
    tag = "v4.1.0";
    hash = "sha256-zhRFEmPYNFLqQCfvdAaG5VBNle9Qm8FepIIIrT9sh88=";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "ghostship";
    version = "1.0.2";

    src = fetchFromGitHub {
      owner = "HarbourMasters";
      repo = "Ghostship";
      tag = "${finalAttrs.version}";
      hash = "sha256-4QIfgBaN6HhPfkP9kRXf14whY5ZaCrJOXEASTnmWSgI=";
      fetchSubmodules = true;
      deepClone = true;
      postFetch = ''
        cd $out
        git branch --show-current > GIT_BRANCH
        git rev-parse --short=7 HEAD > GIT_COMMIT_HASH
        (git describe --tags --abbrev=0 --exact-match HEAD 2>/dev/null || echo "") > GIT_COMMIT_TAG
        rm -rf .git
      '';
    };

    passthru.updateScript = generic-updater {};

    cmakeBuildType =
      if withDebug
      then "RelWithDebInfo"
      else "MinSizeRel";

    patches = [
      # Don't fetch stb as we will patch our own
      ./dont-fetch-stb.patch

      # Can't fetch these torch deps in the sandbox
      (replaceVars ./git-deps.patch {
        libgfxd_src = fetchFromGitHub {
          owner = "glankk";
          repo = "libgfxd";
          rev = "96fd3b849f38b3a7c7b7f3ff03c5921d328e6cdf";
          hash = "sha256-dedZuV0BxU6goT+rPvrofYqTz9pTA/f6eQcsvpDWdvQ=";
        };
        spdlog_src = fetchFromGitHub {
          owner = "gabime";
          repo = "spdlog";
          rev = "79524ddd08a4ec981b7fea76afd08ee05f83755d";
          hash = "sha256-bL3hQmERXNwGmDoi7+wLv/TkppGhG6cO47k1iZvJGzY=";
        };
        yaml-cpp_src = fetchFromGitHub {
          owner = "jbeder";
          repo = "yaml-cpp";
          rev = "2f86d13775d119edbb69af52e5f566fd65c6953b";
          hash = "sha256-GtUTbEaRR3+GfVkt3t8EsqBHVffVKOl8urtQTaHozIo=";
        };
        tinyxml2_src = srcOnly tinyxml-2;
      })
    ];

    nativeBuildInputs = [
      cmake
      copyDesktopItems
      installShellFiles
      lsb-release
      makeWrapper
      ninja
      pkg-config
    ];

    buildInputs = [
      libGL
      libvorbis
      libX11
      libzip
      nlohmann_json
      SDL2
      spdlog
      tinyxml-2
      zenity
    ];

    cmakeFlags = [
      (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DR_LIBS" "${dr_libs}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui'}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBGFXD" "${libgfxd}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PRISM" "${prism}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_STORMLIB" "${stormlib'}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_THREADPOOL" "${thread_pool}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TINYXML2" "${tinyxml-2}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_YAML-CPP" "${yaml-cpp.src}")
      # yaml-cpp is the root dependency which causes a build error.
      # the cause comes from the cmake version range specified in
      # https://github.com/jbeder/yaml-cpp/blob/28f93bdec6387d42332220afa9558060c8016795/CMakeLists.txt#L3
      # until HarbourMasters/Ghostship upgrades yaml-cpp a workaround is to specify our own minimum version
      (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
    ];

    strictDeps = true;

    # dontAddPrefix = true;

    # Linking fails without this
    hardeningDisable = ["format"];

    preConfigure = ''
      mkdir stb
      cp ${stb'} ./stb/${stb'.name}
      cp ${stb_impl} ./stb/${stb_impl.name}
      substituteInPlace libultraship/cmake/dependencies/common.cmake \
        --replace-fail "\''${STB_DIR}" "$(readlink -f ./stb)"
    '';

    postPatch = ''
      # We need to use GetAppDirectoryPath on nix or else it crashes
      substituteInPlace src/port/GameExtractor.cpp \
      --replace-fail "const std::string assets_path = Ship::Context::GetAppBundlePath();" "const std::string assets_path = Ship::Context::GetAppDirectoryPath();"
    '';

    postBuild = ''
      cp ${sdl_gamecontrollerdb}/share/gamecontrollerdb.txt gamecontrollerdb.txt
      ./TorchExternal/src/TorchExternal-build/torch pack ../port ghostship.o2r o2r
    '';

    postInstall = ''
      mv Ghostship ghostship
      installBin {ghostship,TorchExternal/src/TorchExternal-build/torch}
      mkdir -p $out/share/ghostship/
      cp -r assets $out/share/ghostship/
      install -Dm644 -t $out/share/ghostship {ghostship.o2r,config.yml,gamecontrollerdb.txt}
      install -Dm644 ../logo.png $out/share/pixmaps/ghostship.png
      install -Dm644 -t $out/share/licenses/ghostship ../LICENSE.md
      install -Dm644 -t $out/share/licenses/ghostship/libgfxd ${libgfxd}/LICENSE
      install -Dm644 -t $out/share/licenses/ghostship/libultraship ../libultraship/LICENSE
      install -Dm644 -t $out/share/licenses/ghostship/thread_pool ${thread_pool}/LICENSE.txt
    '';

    # Unfortunately, Ghostship really wants a writable working directory
    # Create $HOME/.local/share/ghostship and symlink required files
    # This is pretty hacky and works for now and perhaps upstream might support XDG later
    # Also wrapProgram escapes $HOME to "/homeless-shelter" so use "~" for now

    postFixup = ''
      wrapProgram $out/bin/ghostship \
        --prefix PATH ":" ${lib.makeBinPath [zenity]} \
        --run 'mkdir -p ~/.local/share/ghostship' \
        --run "ln -sf $out/share/ghostship/ghostship.o2r ~/.local/share/ghostship/ghostship.o2r" \
        --run "ln -sf $out/share/ghostship/config.yml ~/.local/share/ghostship/config.yml" \
        --run "ln -sfT $out/share/ghostship/assets ~/.local/share/ghostship/assets" \
        --run "ln -sf $out/share/ghostship/gamecontrollerdb.txt ~/.local/share/ghostship/gamecontrollerdb.txt" \
        --run 'cd ~/.local/share/ghostship'
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "Ghostship";
        icon = "ghostship";
        exec = "ghostship";
        comment = finalAttrs.meta.description;
        genericName = "ghostship";
        desktopName = "ghostship";
        categories = ["Game"];
      })
    ];

    meta = {
      homepage = "https://github.com/HarbourMasters/Ghostship";
      description = "SM64 PC Port";
      mainProgram = "ghostship";
      platforms = ["x86_64-linux"];
      license = with lib.licenses; [
        # libultraship, libgfxd, thread_pool, dr_libs, prism-processor
        mit
        # Ghostship
        cc0
        # Reverse engineering
        unfree
      ];
      hydraPlatforms = [];
    };
  })
