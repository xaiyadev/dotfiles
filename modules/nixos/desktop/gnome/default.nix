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
    cfg = config.${namespace}.desktop.gnome;
in
{
    options.${namespace}.desktop.gnome = {
        enable = mkEnableOption "Starts Gnome and all the important apps! Please use only one desktop at once!";
    };

    config = mkIf cfg.enable {
        services.xserver = {
            enable = true;

            displayManager.gdm.enable = true;
            desktopManager.gnome.enable = true;
        };

        environment.gnome.excludePackages = with pkgs; [
          cheese      # photo booth
          eog         # image viewer
          epiphany    # web browser
          totem       # video player
          yelp        # help viewer
          evince      # document viewer
          geary       # email client
          seahorse    # password manager


          gnome-font-viewer gnome-photos gnome-screenshot gnome-connections
        ];

        environment.systemPackages = with pkgs; [
           gtk4

           dconf-editor
           gnome-tweaks
           gnome-extension-manager

           gnomeExtensions.weather-oclock
           gnomeExtensions.open-bar
           gnomeExtensions.user-themes
           gnomeExtensions.appindicator
           gnomeExtensions.spotify-tray
        ];

        services.udev.packages = with pkgs; [ gnome-settings-daemon ];
    };
}