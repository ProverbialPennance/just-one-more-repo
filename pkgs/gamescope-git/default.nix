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
  rev' = "9416ca9334da7ff707359e5f6aa65dcfff66aa01";
  shortRev = builtins.substring 0 7 rev';
in
  gamescope.overrideAttrs (prevAttrs: {
    pname = "gamescope-git";
    version = "3.16.14.5" + "+${shortRev}";
    src = fetchFromGitHub {
      owner = "ValveSoftware";
      repo = "gamescope";
      rev = "${rev'}";
      sha256 = "sha256-bZXyNmhLG1ZcD9nNKG/BElp6I57GAwMSqAELu2IZnqA=";
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
