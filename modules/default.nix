{
  imports = [
    ./remote-play-whatever.nix
    ./sm64coopdx.nix
    ./xivlauncher-rb.nix
    ./spaghetti-kart.nix
  ];

  nixpkgs.overlays = [
    (import ../overlay.nix)
  ];
}
