{ osConfig, lib, ... }:
let
  inherit (lib) mkIf;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  # TODO: make icon dissapearrs?
  # notification center point/something different?
  services.swaync = mkIf sway.enable {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
    };
  };
}
