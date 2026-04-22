{
  config,
  lib,
  pkgs,
  ...
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
    buildWithDebug = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to build as a `RelWithDebInfo` binary or `MinSizeRel`.
        **N.B** incompatible with other packages than those provided by JOMR.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      if cfg.buildWithDebug
      then [cfg.package.override {withDebug = cfg.buildWithDebug;}]
      else [cfg.package];
  };
}
