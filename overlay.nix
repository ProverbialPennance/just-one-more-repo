final: prev: {
  remote-play-whatever = final.callPackage ./pkgs/RemotePlayWhatever {};
  sm64coopdx = final.callPackage ./pkgs/sm64coopdx {};
  xivlauncher-rb = final.callPackage ./pkgs/xivlauncher-rb {};
  spaghetti-kart-git = final.callPackage ./pkgs/spaghetti-kart-git {};
  starship-sf64 = final.callPackage ./pkgs/starship-sf64 {};
  _2ship2harkinian-git = final.callPackage ./pkgs/_2ship2harkinian-git {};
  shipwright-git = final.callPackage ./pkgs/shipwright-git {};
  perfect-dark-git = final.callPackage ./pkgs/perfect-dark-git {};
  dolphin-memory-engine = final.callPackage ./pkgs/dolphin-memory-engine {};
  factorio-2_0_55 = final.callPackage ./pkgs/factorio/2.0.55 {releaseType = "headless";};
  factorio-2_0_60 = final.callPackage ./pkgs/factorio/2.0.60 {releaseType = "headless";};
  delta-patcher = final.callPackage ./pkgs/delta-patcher {};
  cockatrice-git = final.callPackage ./pkgs/cockatrice-git {};
  # sm64baserom = final.callPackage ./pkgs/sm64baserom {};
  # sm64ex-ap = final.callPackage ./pkgs/sm64ex-ap {sm64baserom = final.callPackage ./pkgs/sm64baserom {};};
}
