{pkgs ? import <nixpkgs> {}}: {
  # This is needed for  the nix-build invocation done by nix-update
  xivlauncher-rb = pkgs.callPackage ./pkgs/xivlauncher-rb {};
  r2modman = pkgs.callPackage ./pkgs/r2modman {};
  perfect-dark-git = pkgs.callPackage ./pkgs/perfect-dark-git {};
}
