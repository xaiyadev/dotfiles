{ lib, config, ... }:
let
  inherit (lib.modules) mkIf;

  displayManager = config.sylveon.system.graphical.displayManager;
in
{

  config = mkIf (displayManager == "gdm") {
    services.xserver.displayManager.gdm = {
      enable = true;
    };
  };

}
