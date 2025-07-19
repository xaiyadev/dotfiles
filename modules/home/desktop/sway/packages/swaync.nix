{ osConfig, lib,  ... }:
let
  inherit (lib) mkIf;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  # SwayNC is right now only used for the notification popup
  services.swaync = mkIf sway.enable {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
    };
 };
}
