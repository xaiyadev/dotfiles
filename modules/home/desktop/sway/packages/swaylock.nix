{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;

  sway = osConfig.sylveon.system.graphical.sway;
in

{

  programs.swaylock = mkIf sway.enable {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      effect-blur = "13x13";
      effect-vignette = "0.4:0.4";

      grace = 6; # Time until you can still exit the lock screen without a password
      grace-no-mouse = true;

      screenshots = true;

      clock = true;
      timestr = "%H:%M";
      datestr = "%d. %b";

      indicator = true;

    };
  };
}
