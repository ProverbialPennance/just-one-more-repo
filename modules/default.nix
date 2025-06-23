{
  imports = [
    ./remote-play-whatever.nix
    ./sm64coopdx.nix
    ./xivlauncher-rb.nix
    ./spaghetti-kart-git.nix
    ./starship-sf64.nix
    ./_2ship2harkinian-git.nix
    ./perfect-dark-git.nix
  ];

  nixpkgs.overlays = [
    (import ../overlay.nix)
  ];
}
