{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.delta-patcher;
in {
  options.programs.delta-patcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable delta-patcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.delta-patcher;
      description = lib.mdDoc ''
        delta-patcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
