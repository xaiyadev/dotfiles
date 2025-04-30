{ osConfig, lib, ... }:
let
  inherit (lib.modules) mkIf;

  windowManager = osConfig.sylveon.system.graphical.windowManagers;
in
{

  imports = [
    ./extensions.nix
  ];

  config = mkIf (builtins.elem "gnome" windowManager) {

    dconf = {

      # TODO: Software that generalizes that?
      settings."org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
        speed = -0.7;
      };

      settings."org/gnome/desktop/interface" = {
        clock-format = "24h";
        show-battery-percentage = true;
      };

    };
  };

}