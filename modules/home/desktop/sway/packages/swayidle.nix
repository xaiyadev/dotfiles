{ pkgs, osConfig, config,  ... }:
let
  windowManagers = osConfig.sylveon.system.graphical.windowManagers;
in
{

  services.swayidle = {
    enable = builtins.elem "sway" windowManagers;
    timeouts =
      [
        { timeout = 300; command = "exec ${config.programs.swaylock.package}/bin/swaylock"; }
      ];

    events =
     [
       { event = "before-sleep"; command = "exec ${config.programs.swaylock.package}/bin/swaylock"; }
     ];

  };
}
