{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.gnome;
in
{
    options.services.gnome = {
        enable = mkEnableOption "custom gnome service";
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
          simple-scan # document scanner
          totem       # video player
          yelp        # help viewer
          evince      # document viewer
          file-roller # archive manager
          geary       # email client
          seahorse    # password manager

          gnome-calculator gnome-calendar
          gnome-font-viewer gnome-photos gnome-screenshot
          gnome-system-monitor gnome-connections
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

        services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    };
}
