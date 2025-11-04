{
  pkgs,
  config,
  lib,
  inputs',
  ...
}:
let
  inherit (lib) getExe;
in
{
  wayland.windowManager.sway.config = {
    window = {
      border = 3;
      titlebar = false;
    };
    gaps = {
      inner = 5;
    };

    floating = {
      # Windows that should be opened in floating mode
      criteria = [
        { class = "tidal-hifi"; }
        { class = "steam"; }
        { class = "Enpass"; }
        { app_id = "nemo"; }
        { app_id = "com.yubico.yubioath"; }

        { app_id = ".blueman-manager-wrapped"; }
        { app_id = "org.pulseaudio.pavucontrol"; }
      ];
    };

    assigns = {
      "4" = [
        { class = "discord"; }
        { class = "teams-for-linux"; }
      ];
    };

    startup = [ 
      # Software
      { command = "${getExe config.programs.nixcord.finalPackage.discord} --start-minimized"; } 

      # Display and configurations
      { command = (getExe pkgs.kanshi); always = true; }
      { command = "${getExe pkgs.brightnessctl} set 68%"; always = true; }

      # Background Services
      { command = (getExe pkgs.sway-audio-idle-inhibit); }
      { command = "${getExe inputs'.vicinae.packages.default} server"; }
    ];
  };
}
