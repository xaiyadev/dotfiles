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
    cfg = config.${namespace}.desktop.sway;
in
{
    options.${namespace}.desktop.sway = {
        enable = mkEnableOption "Activate all the neceasery tools for sway to work";
    };

    config = mkIf cfg.enable {
      /* Packages and other things that need to be installed */
      services.gnome.gnome-keyring.enable = true;
      services.dbus.enable = true;
      
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.enable = true;

      environment.systemPackages = with pkgs; [
        sway
        wayland
        xdg-utils
        glib
        grim
        slurp
        wl-clipboard
        mako
      ];

      /* Desktop and window manager thingies */
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

    };
}
