{
  config,
  lib,
  pkgs,
}:
with lib; let
  cfg = config.programs.sm64ex-ap;
in {
  options.programs.sm64ex-ap = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable sm64ex-ap.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.sm64ex-ap;
      description = lib.mdDoc ''
        sm64ex-ap package to use.
      '';
    };
    baserom = mkOption {
      type = types.package;
      default = pkgs.sm64baserom;
      description = lib.mdDoc ''
        sm64baserom to use.

        Defaults to a US baserom, see our sm64baserom package for a network-fetchable example.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [(cfg.package.overrideAttrs {baserom = cfg.baserom;})];
  };
}
