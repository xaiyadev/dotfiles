{ pkgs, osConfig,  ... }:
let
  windowManagers = osConfig.sylveon.system.graphical.windowManagers;
in
{

  programs.swaylock = {
    enable = builtins.elem "sway" windowManagers;
    package = pkgs.swaylock-effects;

    settings = {
      /*
       * Swaylock Effects Settings
      */

      effect-blur = "13x13";
      effect-vignette = "0.4:0.4";

      grace = 2; # Time until you can still exit the lock screen without a password
      grace-no-mouse = true;

      screenshots = true;

      clock = true;
      timestr = "%H:%M";
      datestr = "%d. %b";

      indicator = true;

    };
  };
}