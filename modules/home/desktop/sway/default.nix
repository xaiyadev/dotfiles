{ osConfig, lib, pkgs, ... }:
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
          "${modifier}+e" = "exec ${pkgs.wofi-emoji}/bin/wofi-emoji";
          "${modifier}+shift+Escape" = "exec ${pkgs.swaylock-effects}/bin/swaylock";
          "${modifier}+Escape" = "exec ${pkgs.wlogout}/bin/wlogout";
        };
      };
    };
  };
}