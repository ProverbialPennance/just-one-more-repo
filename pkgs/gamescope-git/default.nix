# MIT License
#
# Copyright (c) 2023 Pedro Henrique Lara Campos <nyx@pedrohlc.com>
#
{
  lib,
  generic-updater,
  fetchFromGitHub,
  gamescope,
}: let
  rev' = "70614184ebf6d12dd1e390082d98ad569e7601aa";
  shortRev = builtins.substring 0 7 rev';
in
  gamescope.overrideAttrs (prevAttrs: {
    pname = "gamescope-git";
    version = "3.16.14.5" + "+${shortRev}";
    src = fetchFromGitHub {
      owner = "ValveSoftware";
      repo = "gamescope";
      rev = "${rev'}";
      sha256 = "sha256-StmXf8G3SIacddFxg5xMyvHI2ESiaWaivw3ZM9jAQM4=";
      fetchSubmodules = true;
    };

    passthru.updateScript = generic-updater {
      extraArgs = [
        "--version=branch"
      ];
    };

    postPatch =
      prevAttrs.postPatch
      + ''
        substituteInPlace layer/VkLayer_FROG_gamescope_wsi.cpp \
          --replace-fail 'WSI] Surface' 'WSI ${shortRev}] Surface'
        substituteInPlace src/meson.build \
          --replace-fail "'git', 'describe', '--always', '--tags', '--dirty=+'" "'echo', '${prevAttrs.src.rev}'"

        patchShebangs default_extras_install.sh
      '';
  })
