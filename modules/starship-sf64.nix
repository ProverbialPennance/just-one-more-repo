{
  config,
  lib,
  pkgs,
}:
with lib; let
  cfg = config.programs.starship-sf64;
in {
  options.programs.starship-sf64 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable starship-sf64.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.starship-sf64;
      description = lib.mdDoc ''
        starship-sf64 package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
