# Just One More Repo

because _what's the harm in one more flake input?_

---

I would not presently consider this stable, however, I am mostly attempting to migrate my individual packages into this repo

## usage

Just add it to your flake.nix as usual:

```nix
{
  inputs = {
    # NOTE: replace nixos-25.05 with the desired version, such as nixos-unstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    just-one-more-repo = {
        url = "github:ProverbialPennance/just-one-more-repo";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    just-one-more-repo,
  }:
  {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          # this adds the overlay introducing new packages and swapping ones such as sm64coopdx
          just-one-more-repo.nixosModules.default
        ];
      };
    };
  };
}
```

and then you can either add packages to `environment.systemPackages` as usual,
or you can use our modules like so:

```nix
{
  pkgs,
  ...
}: {
  programs.sm64coopdx = {
    enable = true;
    coopNet.openFirewall = true;
  };
}
```

## cachix

The cachix instance should be regularly updated, the following should be enough to start using it

```nix
nixConfig = {
    extra-substituters = [
      "https://just-one-more-cache.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "just-one-more-cache.cachix.org-1:4nShcKEgcUEVlJqKFrgDwoGfqLnw5KPG4UDTV02jnr4="
    ];
  };
```
