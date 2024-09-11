{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  specialArgs,
  ...
}:
with lib;
let
    cfg = config.${namespace}.desktop.config.sway;
in
{
    options.${namespace}.desktop.config.sway = {
        enable = mkEnableOption "Setup sway settings!";
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
          dmenu
      ];

      wayland.windowManager.sway = {
        enable = true;
        config = {
          bars = [ ];

          input = { "*" = { xkb_layout = "de"; }; };
          modifier = "Mod4";
          terminal = "alacritty";

          window = {
            border = 2;
            titlebar = false;
          };

          gaps = {
            inner = 10;

          };
        };
	extraConfig = ''
	  exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
	'';
      };

      ${namespace} = {
        tools = {
          alacritty.enable = true;
          waybar.enable = true;
        };
        desktop.config.gnome = {
            enable = true;
            dconf = false;
        };

      };

    };
}
