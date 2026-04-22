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
