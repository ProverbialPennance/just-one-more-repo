{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.perfect-dark-git;
in {
  options.programs.perfect-dark-git = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable perfect-dark-git.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.perfect-dark-git;
      description = lib.mdDoc ''
        perfect-dark-git package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
