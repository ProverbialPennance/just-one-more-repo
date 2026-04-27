{lib, ...}: let
  paths = lib.filesystem.listFilesRecursive ./.;
in {
  allChecks = lib.genAttrs (lib.filter (pathString: !lib.strings.hasSuffix "default" pathString) (lib.forEach paths (path: lib.strings.removeSuffix ".nix" (lib.lists.last (builtins.split "/" (toString path))))));
}
