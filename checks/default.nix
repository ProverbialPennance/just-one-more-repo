{lib, ...}: let
  paths = lib.filesystem.listFilesRecursive ./.;
in {
  allChecks = lib.genAttrs (lib.filter (pathString: !lib.strings.hasSuffix "default.nix" pathString) (lib.forEach paths (path: toString path)));
}
