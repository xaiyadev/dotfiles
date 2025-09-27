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

      # Adds a systemd target, for tools like kanshi to work
      systemd = {
        enable = true;
        xdgAutostart = true;
      };

      config = {
        inherit modifier;


        menu = (getExe inputs'.vicinae.packages.default);
        terminal = "${pkgs.kitty}/bin/kitty";

        keybindings = mkOptionDefault {
          "${modifier}+Escape" = "exec ${config.programs.swaylock.package}/bin/swaylock";

          "${modifier}+shift+s" =
            ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy''; # Take a screenshot

          "${modifier}+e" = ''exec ${pkgs.nemo-with-extensions}/bin/nemo'';
        };

      };

      extraConfig = concatStringsSep "\n" [
        # Touchpad configuration
        "bindgesture swipe:right workspace prev"
        "bindgesture swipe:left workspace next"

        # SwayFX spesific configuration
        "shadows enable"
        "corner_radius 13"

        # Lower the opacity of specifc windows
        ''for_window [app_id="^kitty$"] opacity 0.94''

        # Always load kanshi after a sway-reload, that prevents from the monitors bugging out
        "exec_always ${getExe pkgs.kanshi}"

        "exec ${getExe pkgs.brightnessctl} set 40%" # Update brightness when starting sway
        "exec ${getExe inputs'.vicinae.packages.default} server" # Start the vicinae Server if sway startup
      ];
    };
  };
}
