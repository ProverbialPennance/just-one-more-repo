{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.shipwright-git;
in {
  options.programs.shipwright-git = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable shipwright-git.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.shipwright-git;
      description = lib.mdDoc ''
        shipwright-git package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
