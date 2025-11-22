{
  lib,
  generic-updater,
  perl,
  jq,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "scopebuddy";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "HikariKnight";
    repo = "ScopeBuddy";
    rev = "${finalAttrs.version}";
    sha256 = "sha256-e3+/IKB9w50snYNa+85TZ0T2e4FmRmnmJK3NwGGunbc=";
  };

  passthru.updateScript = generic-updater {};

  nativeBuildInputs = [makeWrapper];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    echo $(ls ./bin)
    install -Dm0555 ./bin/scb -t $out/bin
    install -Dm0555 ./bin/scopebuddy -t $out/bin
    runHook postInstall
  '';

  fixupPhase = ''
    wrapProgram $out/bin/scopebuddy --prefix PATH : ${lib.makeBinPath [perl jq]}
    wrapProgram $out/bin/scb --prefix PATH : ${lib.makeBinPath [perl jq]}
  '';

  meta = with lib; {
    description = "A manager script to make gamescope easier to use on desktop ";
    homepage = "https://github.com/HikariKnight/ScopeBuddy";
    license = licenses.asl20;
    maintainers = [];
    platforms = platforms.linux;
    mainProgram = "scb";
  };
})
