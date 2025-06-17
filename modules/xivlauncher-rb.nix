{
  config,
  lib,
  pkgs,
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
    package = mkOption {
      type = types.package;
      default = pkgs.xivlauncher-rb;
      description = lib.mdDoc ''
        xivlauncher-rb package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
