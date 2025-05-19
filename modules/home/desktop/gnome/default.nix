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

    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";

      # TODO: Software that generalizes that?
      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
        speed = -0.7;
      };

      "org/gnome/desktop/interface" = {
        clock-format = "24h";
        show-battery-percentage = true;
      };

      "org/gnome/desktop/wm/preferences" = {
        audible-bell = false;
        button-layout = ":minimize,maximize,close";
      };

    };
  };

}