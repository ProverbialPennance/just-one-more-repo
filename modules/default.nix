{
  imports = [
    ./remote-play-whatever.nix
    ./sm64coopdx.nix
    ./xivlauncher-rb.nix
  ];

  nixpkgs.overlays = [
    (import ../overlay.nix)
  ];
}
