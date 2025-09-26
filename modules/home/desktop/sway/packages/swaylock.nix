{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
let
  inherit (lib) 
    mkIf
    mkOptionDefault
    ;

  sway = osConfig.sylveon.system.graphical.sway;
  modifier = config.wayland.windowManager.sway.config.modifier;
in

{
  config = mkIf sway.enable {
    programs.swaylock = {
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

    wayland.windowManager.sway.config.keybindings = mkOptionDefault {
      "${modifier}+Escape" = "exec ${config.programs.swaylock.package}/bin/swaylock";
    };
  };
}
