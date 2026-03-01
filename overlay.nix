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
  factorio-2_0_55 = final.callPackage ./pkgs/factorio/stable/2.0.55 {releaseType = "headless";};
  factorio-2_0_60 = final.callPackage ./pkgs/factorio/stable/2.0.60 {releaseType = "headless";};
  factorio-2_0_66 = final.callPackage ./pkgs/factorio/stable/2.0.66 {releaseType = "headless";};
  factorio-2_0_69 = final.callPackage ./pkgs/factorio/stable/2.0.69 {releaseType = "headless";};
  factorio-2_0_71 = final.callPackage ./pkgs/factorio/stable/2.0.71 {releaseType = "headless";};
  factorio-experimental = final.callPackage ./pkgs/factorio/experimental/latest {releaseType = "headless";};
  delta-patcher = final.callPackage ./pkgs/delta-patcher {};
  cockatrice-git = final.callPackage ./pkgs/cockatrice-git {};
  scopebuddy = final.callPackage ./pkgs/scopebuddy {};

  r2modman = final.callPackage ./pkgs/r2modman {};
  generic-updater = final.callPackage ./scripts/update/generic-updater.nix {};

  shipwright-ap = final.callPackage ./pkgs/shipwright-ap {};

  discord-krisp = final.callPackage ./pkgs/discord-krisp {};
  # discord-ptb-krisp = final.callPackage ./pkgs/discord-krisp {discord = prev.discord-ptb;};
  # discord-canary-krisp = final.callPackage ./pkgs/discord-krisp {discord = prev.discord-canary;};
  # sm64baserom = final.callPackage ./pkgs/sm64baserom {};
  # sm64ex-ap = final.callPackage ./pkgs/sm64ex-ap {sm64baserom = final.callPackage ./pkgs/sm64baserom {};};
}
