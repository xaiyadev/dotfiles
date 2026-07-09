# TODO: install spicetify
{ lib, config, pkgs, inputs', inputs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.lists) any;

  players = config.sylveon.programs.music-players;
in
{
  config = mkIf (any (x: x == "spotify") players) {
    sylveon.packages = {
      inherit (pkgs) spotify;
    };
  };
}
