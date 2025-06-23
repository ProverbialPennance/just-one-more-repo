final: prev: {
  remote-play-whatever = final.callPackage ./pkgs/RemotePlayWhatever {};
  sm64coopdx = final.callPackage ./pkgs/sm64coopdx {};
  xivlauncher-rb = final.callPackage ./pkgs/xivlauncher-rb {};
  spaghetti-kart = final.callPackage ./pkgs/spaghetti-kart {};
  starship-sf64 = final.callPackage ./pkgs/starship-sf64 {};
  _2ship2harkinian-git = final.callPackage ./pkgs/_2ship2harkinian-git {};
  perfect-dark-git = final.callPackage ./pkgs/perfect-dark-git {};
  # sm64baserom = final.callPackage ./pkgs/sm64baserom {};
  # sm64ex-ap = final.callPackage ./pkgs/sm64ex-ap {sm64baserom = final.callPackage ./pkgs/sm64baserom {};};
}
