{
  self,
  lib,
  pkgs,
}: let
  factorioPkgs =
    lib.filter (
      elem: elem != null
    ) (
      lib.flatten (
        lib.lists.unique (
          lib.forEach (
            lib.attrNames pkgs
          ) (name: lib.match "(factorio-experimental|factorio-[[:digit:]].+)" name)
        )
      )
    );
in
  pkgs.testers.nixosTest (finalAttrs: {
    name = "Factorio";

    nodes = lib.listToAttrs (lib.forEach factorioPkgs (p: {
      name = p;
      value = {config, ...}: {
        imports = [self.nixosModules.default];

        services.factorio = {
          enable = true;
          package = pkgs."${p}";
        };
      };
    }));

    globalTimeout = 1800;

    testScript = {nodes, ...}: ''
      print(machines)

      start_all()

      for machine in machines:
        print(machine)
        print("waiting for factorio.service")
        machine.wait_for_unit("factorio.service")

        print("checking status")
        machine.succeed("systemctl status factorio.service --no-pager -l")
    '';
  })
