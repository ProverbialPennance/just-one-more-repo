{
  config,
  lib,
  pkgs,
}:
with lib; let
  cfg = config.programs.remote-play-whatever;
in {
  options.programs.remote-play-whatever = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable RemotePlayTogether.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.remote-play-whatever;
      description = lib.mdDoc ''
        RemotePlayWhatever package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
