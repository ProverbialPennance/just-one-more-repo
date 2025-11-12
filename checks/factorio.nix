{
  self,
  lib,
  pkgs,
}: let
  factorioPkgs = lib.filter (
    name: lib.hasPrefix "factorio" name
  ) (lib.attrNames self.packages);
in
  pkgs.testers.nixosTest (finalAttrs: {
    name = "Factorio";

    nodes = lib.listToAttrs (lib.forEach factorioPkgs (p: {
      name = p;
      value = {config, ...}: {
        imports = [self.nixosModules.default];

        services.factorio = {
          enable = true;
          package = self.pkgs."${p}";
        };
      };
    }));

    # nodes = lib.listToAttrs (lib.forEach factorioPkgs (pkg: {
    #   name = pkg;
    #   value = {config, ...}: {
    #     imports = [self.nixosModules.default];

    #     services.factorio = {
    #       enable = true;
    #       package = pkg;
    #     };
    #   };
    # }));

    globalTimeout = 1800;

    testScript = {nodes, ...}: ''
      start_all()

      for machine in machines:
        machine.wait_for_unit("network-online.target")
        machine.wait_for_unit("factorio.service")

        machine.succeed("systemctl status factorio.service --no-pager -l")
        machine.shutdown()
    '';
  })
