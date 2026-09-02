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
  config = mkIf (clients != null && any (x: x == "minecraft") clients) {
    programs.prismlauncher.enable = true;
  };
}
