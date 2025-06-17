{pkgs ? import <nixpkgs> {}}: {
  # This is needed for  the nix-build invocation done by nix-update
  xivlauncher-rb = pkgs.callPackage ./pkgs/xivlauncher-rb {};
}
