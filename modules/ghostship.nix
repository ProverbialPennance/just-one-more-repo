{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.ghostship;
in {
  options.programs.ghostship = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable ghostship.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.ghostship;
      description = lib.mdDoc ''
        ghostship package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
