{ osConfig, lib, ... }:
let
  inherit (lib) mkIf;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  services.swaync = mkIf sway.enable {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";

      image-visibility = "never";
    };
  };
}
