{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.lists) any;

  players = config.sylveon.programs.music-players;
in
{
  config = mkIf (players != null && any (x: x == "youtube-music") players) {
    sylveon.packages = { inherit (pkgs) pear-desktop; };
  };
}
