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
  # TODO switch from lutris away
  config = mkIf (clients != null && any (x: x == "bottles") clients) {
    sylveon.packages = {
      bottles = (pkgs.bottles.override { removeWarningPopup = true; });
    };
  };
}
