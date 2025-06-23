{
  config,
  lib,
  pkgs,
}:
with lib; let
  cfg = config.programs.spaghetti-kart;
in {
  options.programs.spaghetti-kart = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable spaghetti-kart.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.spaghetti-kart;
      description = lib.mdDoc ''
        spaghetti-kart package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
