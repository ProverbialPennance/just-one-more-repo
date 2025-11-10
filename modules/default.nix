{
  imports = [
    ./remote-play-whatever.nix
    ./sm64coopdx.nix
    ./xivlauncher-rb.nix
    ./spaghetti-kart-git.nix
    ./starship-sf64.nix
    ./_2ship2harkinian-git.nix
    ./shipwright-git.nix
    ./perfect-dark-git.nix
    ./dolphin-memory-engine.nix
    ./binfmt.nix
  ];

  nixpkgs.overlays = [
    (import ../overlay.nix)
  ];
}
