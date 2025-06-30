{ osConfig, lib, pkgs, config, ... }:
let
  inherit (lib.modules) mkIf mkOptionDefault;

  modifier = "Mod4";
  windowManagers = osConfig.sylveon.system.graphical.windowManagers;
in
{
  imports = [
    ./packages # Load extra packages
    ./config # Load sway configurations
  ];

  config = mkIf (builtins.elem "sway" windowManagers) {
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

        terminal = "${pkgs.kitty}/bin/kitty";

        keybindings = mkOptionDefault {
          "${modifier}+Escape" = "exec ${config.programs.swaylock.package}/bin/swaylock"; # Lock screen
          "${modifier}+shift+s" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy''; # Take a screenshot
        };

      };

      extraConfig = ''
        bindgesture swipe:right workspace prev
        bindgesture swipe:left workspace next

        shadows enable
        corner_radius 13

        # Lower the opacity of specifc windows
        for_window [app_id="^kitty$"] opacity 0.9
        for_window [class="^tidal-hifi"] opacity 0.9

        exec_always ${pkgs.kanshi}/bin/kanshi
      '';
    };
  };
}