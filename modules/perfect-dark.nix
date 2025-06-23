{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.perfect-dark;
in {
  options.programs.perfect-dark = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable perfect-dark.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.perfect-dark;
      description = lib.mdDoc ''
        perfect-dark package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
