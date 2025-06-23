{
  config,
  lib,
  pkgs,
}:
with lib; let
  cfg = config.programs._2ship2harkinian-git;
in {
  options.programs._2ship2harkinian-git = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable _2ship2harkinian-git.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs._2ship2harkinian-git;
      description = lib.mdDoc ''
        _2ship2harkinian-git package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
