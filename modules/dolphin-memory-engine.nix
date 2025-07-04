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

    setCap = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        whether to set default capabilities such that dolphin-memory-engine can attach to dolphin.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    security.wrappers.dolphin-memory-engine = mkIf cfg.setCap {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_ptrace=eip";
      source = "${cfg.package}/bin/dolphin-memory-engine";
    };
  };
}
