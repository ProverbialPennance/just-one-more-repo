{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.dolphin-memory-engine;
in {
  options.programs.dolphin-memory-engine = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable dolphin-memory-engine.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.dolphin-memory-engine;
      description = lib.mdDoc ''
        dolphin-memory-engine package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
