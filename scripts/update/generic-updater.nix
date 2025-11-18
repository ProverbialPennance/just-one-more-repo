{
  lib,
  nix-update,
}: {
  attrPath ? null,
  extraArgs ? [],
}:
["${lib.getExe nix-update}" "--flake"] ++ extraArgs ++ lib.optionals (attrPath != null) [attrPath]
