{
  self,
  pkgs,
}:
pkgs.testers.nixosTest (
  finalAttrs: {
    name = "dotnet binfmt_misc integration test";

    nodes = {
      base = {config, ...}: {
        imports = [self.nixosModules.default];

        programs.dotnet.binfmt = true;
      };
      combined = {config, ...}: {
        imports = [self.nixosModules.default];

        programs.dotnet.binfmt = true;
        programs.dotnet.package = with pkgs.dotnetCorePackages;
          combinePackages [
            sdk_8_0-bin
            sdk_9_0-bin
            sdk_10_0-bin
          ];
      };
    };

    globalTimeout = 300;

    testScript = {nodes, ...}: ''
      start_all()

      base_command = base.execute("cat /etc/dotnet/install_location")
      assert(base_command[0] == 0)
      print(base_command[1])
      assert(base_command[1] != "")
      assert("dotnet" in base_command[1])

      combined_command = combined.execute("cat /etc/dotnet/install_location")
      assert(combined_command[0] == 0)
      print(combined_command[1])
      assert(combined_command[1] != "")
      assert("dotnet" in combined_command[1])

      combined_command = combined.execute("ls $(cat /etc/dotnet/install_location | sed 's/$/\/sdk/g')")
      assert(combined_command[0] == 0)
      print(combined_command[1])
      assert(combined_command[1] != "")
      assert("10.0" in combined_command[1])
      assert("9.0" in combined_command[1])
      assert("8.0" in combined_command[1])
    '';
  }
)
