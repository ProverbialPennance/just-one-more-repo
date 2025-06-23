{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.sm64coopdx;
in {
  options.programs.sm64coopdx = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable sm64coopdx.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.sm64coopdx;
      description = lib.mdDoc ''
        sm64coopdx package to use.
      '';
    };
    coopNet.openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        whether to open networking ports used for multiplayer.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    #
    networking.firewall = lib.mkMerge [
      ((lib.mkIf cfg.coopNet.openFirewall) {
        # TODO: check whether sm64coopdx uses TCP or UDP for co-op
        allowedTCPPorts = [7777 34197];
        allowedUDPPorts = [7777 34197];
      })
    ];
  };
}
