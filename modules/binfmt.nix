{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.dotnet;
in {
  options.programs.dotnet = {
    binfmt = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable binfmt registration to run .NET Core applications
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.dotnet-runtime_10;
      description = ''
        The package to use for .NET Core applications

        Example: ```
         package = with pkgs.dotnetCorePackages;
           combinePackages [
            sdk_6_0_1xx-bin
            sdk_7_0_3xx-bin
            sdk_8_0-bin
            sdk_9_0-bin
            sdk_10_0-bin
          ];
        ```
      '';
    };
  };

  config = mkIf cfg.binfmt {
    environment = {
      systemPackages = [cfg.package];
      etc = {
        "dotnet/install_location".text = "${cfg.package}/share/dotnet";
      };
    };
    boot.binfmt.registrations = {
      "dotnet" = {
        wrapInterpreterInShell = false;
        interpreter = lib.getExe cfg.package;
        recognitionType = "magic";
        offset = 0;
        magicOrExtension = "MZ";
      };
    };
  };
}
