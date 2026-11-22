# TODO: install spicetify
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
  config = mkIf (players != null && any (x: x == "spotify") players) {
    sylveon.packages = {
      inherit (pkgs) spotify;
    };
  };
}
