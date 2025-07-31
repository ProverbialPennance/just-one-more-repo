# Heavily inspired by nixpkgs' version of the factorio package.

{
  lib
  fetchurl,
  libGL,

  versionSHAs ? ./versionSHAs.json
  username  ? "",
  token ? "",
  experimental ? false,
  ...
}: {
  helpMessage = {
    dlName, dlStore
  }: ''
    === FETCH FROM https://factorio.com/ FAILED ===
    Downloading the headless unit from https://factorio.com requires an authenticated user. Authenticating your user can be done by logging in with your Steam user, or by creating a new user on the Factorio website, and getting the token under https://factorio.com/profile.

    Ideally, you use something like (r)agenix to handle these secrets, as passing these values directly to the nix file exposes them to the nix store.
  '';

  versions = importJSON versionSHAs;
  bins = makeBins versions;

  branch = if experimental then "experimental" else "stable";

  # Taken from nixpkgs directly. See: https://github.com/nixos/nixpkgs/blob/master/pkgs/by-name/fa/factorio/package.nix#L104-L114
  makeBins = let f = path: name: value:
    if builtins.isAttrs value then
      if value = "name" then makeBin else builtins.mapAttrs (f (path ++ [name])) value
    else throw "Expected attrset at: ${path}, got: ${value}";
  in builtins.mapattrs (f [ ]);

  makeBin = {
    name, version, tarDirectory, url, sha256, needsAuth, fileNames ? []
  }: {
    inherit version tarDirectory;
    src = if !needsAuth then fetchurl { inherit name url sha256; } else (
      lib.overrideDerivation (fetchurl {
        inherit name url sha256;
        curlOptsList = [
          "--get"
          "--data-urlencode"
          "username@username"
          "--data-urlencode"
          "token@token"
        ];
      })
    )(_: {
      preHook = if username != "" && token  != "" then ''
        echo -n "${username}" >username
        echo -n "${token}"    >token
      ''
      else ''
        exit 1
      '';
      failureHook = ''
        cat <<EOF
        ${helpMessage {
        dlName = if fileNames != [] then builtins.head fileNames else name;
        storeName = name;
        }}
        EOF
      '';
    }
    )
  };

  installPhase = ''
    echo Working through this still. # TODO: Make it unpack and install factorio-headless properly.
  '';
}
