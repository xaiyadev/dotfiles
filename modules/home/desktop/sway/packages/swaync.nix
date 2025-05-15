{ osConfig,  ... }:
let
  windowManagers = osConfig.sylveon.system.graphical.windowManagers;
in
{

  services.swaync = {
    enable = builtins.elem "sway" windowManagers;

    settings = {
      positionX = "right";
      positionY = "top";

      fit-to-screen = false;
      control-center-height = 700;
      control-center-margin-top = 5;
      control-center-margin-right = 10;
    };
 };
}
