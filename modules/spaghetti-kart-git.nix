{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.spaghetti-kart-git;
in {
  options.programs.spaghetti-kart-git = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable spaghetti-kart-git.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.spaghetti-kart-git;
      description = lib.mdDoc ''
        spaghetti-kart-git package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
