{
  pkgs,
  osConfig,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  services.swayidle = mkIf sway.enable {
    enable = true;

    timeouts = [
      {
        timeout = 300;
        command = "exec ${config.programs.swaylock.package}/bin/swaylock";
      }
    ];

    events = [
      {
        event = "before-sleep";
        command = "exec ${config.programs.swaylock.package}/bin/swaylock";
      }
    ];

  };
}
