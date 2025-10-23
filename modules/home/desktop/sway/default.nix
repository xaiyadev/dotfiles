{
  osConfig,
  lib,
  pkgs,
  config,
  inputs',
  ...
}:
let
  inherit (lib)
    mkIf
    mkOptionDefault
    concatStringsSep
    getExe
    ;

  modifier = "Mod4";
  sway = osConfig.sylveon.system.graphical.sway;
in
{
  imports = [
    ./packages # Load extra packages
    ./config # Load sway configurations
  ];

  config = mkIf sway.enable {
    wayland.windowManager.sway = {
      enable = true;

      # Package is set to null because it is already created in the original config
      package = null;

      systemd = {
        enable = true;
        xdgAutostart = true;
      };

      config = {
        inherit modifier;
        terminal = "${getExe config.programs.kitty.package}";

        keybindings = mkOptionDefault {
          "${modifier}+Escape" = "exec ${getExe config.programs.swaylock.package}";

          "${modifier}+shift+s" =
            ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy''; # Take a screenshot

          "${modifier}+e" = ''exec ${pkgs.nemo-with-extensions}/bin/nemo'';
        };

      };

      extraConfig = concatStringsSep "\n" [
        # SwayFX spesific configuration
        "shadows enable"
        "corner_radius 13"

        "exec_always ${getExe pkgs.kanshi}" # Always load kanshi after a sway-reload, that prevents from the monitors bugging out
        "exec ${getExe pkgs.sway-audio-idle-inhibit}" # stops swayidle from stopping when playing audio; TODO: add waybar integration?

        "exec ${getExe pkgs.brightnessctl} set 40%" # Update brightness when starting sway
        "exec ${getExe inputs'.vicinae.packages.default} server" # Start the vicinae Server if sway startup TODO: buggy if in another tty

      ];
    };
  };
}
