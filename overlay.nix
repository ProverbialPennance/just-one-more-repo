{
  flakes ? {},
  nixpkgs ? flakes.nixpkgs,
  self ? flakes.self,
}: final: prev: {
  remote-play-whatever = final.callPackage ./pkgs/RemotePlayWhatever {};
  sm64coopdx = final.callPackage ./pkgs/sm64coopdx {};
  xivlauncher-rb = final.callPackage ./pkgs/xivlauncher-rb {};
  # sm64baserom = final.callPackage ./pkgs/sm64baserom {};
  # sm64ex-ap = final.callPackage ./pkgs/sm64ex-ap {sm64baserom = final.callPackage ./pkgs/sm64baserom {};};
}
