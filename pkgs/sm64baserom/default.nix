{
  fetchurl,
  runCommand,
  _url ? "",
  _hash ? "",
  region ? "us",
}: let
  file = fetchurl {
    url = _url;
    hash = _hash;
  };
  filename = "baserom.${region}.z64";
  result = runCommand "baserom-${region}-safety-dir" {} ''
    mkdir $out
    cp ${file} $out/${filename}
  '';
in
  result
  // {
    romPath = "${result.outPath}/${filename}";
  }
