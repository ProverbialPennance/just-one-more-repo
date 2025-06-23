{
  description = "Because what's just one more flake, right?";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  } @ inputs: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      # "aarch64-darwin" # no means of testing at this time
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    pkgsFor = system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [self.overlays.default];
      };
      overlay = self.overlays.default pkgs pkgs;
    in
      overlay;
  in {
    inherit (import ./flake.nix) nixConfig;
    packages = forAllSystems pkgsFor;

    overlays.default = import ./overlay.nix;
    nixosModules.default = import ./modules;

    formatter = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        pkgs.alejandra
    );
  };

  nixConfig = {
    extra-substituters = [
      "https://just-one-more-cache.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "just-one-more-cache.cachix.org-1:4nShcKEgcUEVlJqKFrgDwoGfqLnw5KPG4UDTV02jnr4="
    ];
  };
}
