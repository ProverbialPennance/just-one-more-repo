{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.xivlauncher-rb;
in {
  options.programs.xivlauncher-rb = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable xivlauncher-rb.
      '';
    };

    enableGameMode = mkOption {
      type = types.bool;
      default = config.programs.gamemode.enable;
      defaultText = literalExpression "config.programs.gamemode.enable";
      description = ''
        Enable the ability to use GameMode with xivlauncher.

        This will conditionally add the gamemode package to the launcher's environment,
        it is also neccessary to ensure that the gamemode module is enabled on the host.
      '';
    };

    enableMangohud = mkOption {
      type = types.bool;
      default =
        lib.lists.length (lib.lists.filter (
            elem: lib.strings.hasInfix "mangohud" (toString elem)
          )
          config.environment.systemPackages)
        != 0;
      defaultText = literalExpression "lib.lists.length (lib.lists.filter(elem: lib.strings.hasInfix \"mangohud\" (toString elem))) != 0";
      description = ''
        Enable the ability to use mangohud with xivlauncher.

        This will conditionally add mangohud to launcher's environment.
        it is also neccessary to ensure that mangohud
        is available in the host environment as well.
      '';
    };

    nvidia = {
      enableDLSS = mkOption {
        type = types.bool;
        default = config.hardware.nvidia.enabled;
        defaultText = literalExpression "";
        description = ''
          Enable DLSS support in ffxiv / xivlauncher.

          Also needs nvngxPath set.
        '';
      };
      nvngxPath = mkOption {
        type = types.string;
        default = "${config.hardware.nvidia.package}/lib/nvidia/wine";
        defaultText = literalExpression "\${config.hardware.nvidia.package}/lib/nvidia/wine";
        description = ''
          EXPERIMENTAL

          See how a default nvngxPath plays with the module being consumed
        '';
      };
    };

    package = mkOption {
      type = types.package;
      default = pkgs.xivlauncher-rb;
      description = lib.mdDoc ''
        xivlauncher-rb package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (cfg.package.override {
        useGameMode = cfg.enableGameMode;
        nvngxPath =
          if cfg.nvidia.enableDLSS
          then cfg.nvidia.nvngxPath
          else "";
        useMangoHud = cfg.enableMangohud;
      })
    ];
  };
}
