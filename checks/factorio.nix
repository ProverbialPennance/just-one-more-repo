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
    # REASON: the python test runner faults us with an error
    # in the code we have to use to re-access the list of machines/vms
    # being utilised. Previously this was accessible in our test's scope
    # but it appears to have been removed. We are faking our way back to
    # having it, but the typechecker will fault us without providing
    # pedantic type hints.
    skipTypeCheck = true;

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
      # at some point 'machines' got removed from the harness
      # so we have to fake our way back around to it
      scope = locals()
      machines_q = scope.get("machines_qemu")
      machines_n = scope.get("machines_nspawn")
      machines = [*machines_q, *machines_n]
      start_all()

      for machine in machines:
        print(machine)
        print("waiting for factorio.service")
        machine.wait_for_unit("factorio.service")

        print("checking status")
        machine.succeed("systemctl status factorio.service --no-pager -l")
    '';
  })
