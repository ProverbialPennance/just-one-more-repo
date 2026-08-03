{
  lib,
  generic-updater,
  gawk,
  perl,
  jq,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "scopebuddy";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "OpenGamingCollective";
    repo = "ScopeBuddy";
    rev = "${finalAttrs.version}";
    sha256 = "sha256-Z4KE6Qs5dcNdoEra1sx69I8EsxztAeVNGgO0ltYz7r0=";
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
    wrapProgram $out/bin/scopebuddy --prefix PATH : ${lib.makeBinPath [perl jq gawk]}
    wrapProgram $out/bin/scb --prefix PATH : ${lib.makeBinPath [perl jq gawk]}
  '';

  meta = with lib; {
    description = "A manager script to make gamescope easier to use on desktop ";
    changelog = "https://github.com/HikariKnight/ScopeBuddy/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/HikariKnight/ScopeBuddy";
    license = licenses.asl20;
    maintainers = [];
    platforms = platforms.linux;
    mainProgram = "scb";
  };
})
