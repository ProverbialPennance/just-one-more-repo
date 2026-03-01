{
  lib,
  writers,
  discord,
  python3Packages,
  ...
}: let
  patch-krisp = writers.writePython3 "krisp-patcher" {
    libraries = with python3Packages; [
      capstone
      pyelftools
    ];

    flakeIgnore = [
      "E501"
      "F403"
      "F405"
    ];
  } (builtins.readFile ./krisp-patcher.py);
  binaryName = lib.last (builtins.split "/" (lib.getExe discord));
  node_module = "\\$HOME/.config/discord/${discord.version}/modules/discord_krisp.node";
in
  discord.overrideAttrs (prevAttrs: {
    postInstall =
      prevAttrs.postInstall
      + ''
        wrapProgramShell $out/opt/${binaryName}/${binaryName} \
          --run "${patch-krisp} ${node_module}"
      '';
    passthru = removeAttrs prevAttrs.passthru ["updateScriipt"];
  })
