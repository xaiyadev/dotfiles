{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.lists) any;

  clients = config.sylveon.programs.game-clients;
in
{
  config = mkIf (clients != null && any (x: x == "steam") clients) {
    sylveon.packages = {
      inherit (pkgs) 
        steam
        gamescope
        deadlock-mod-manager # maybe move?
        ;
    };
  };
}
