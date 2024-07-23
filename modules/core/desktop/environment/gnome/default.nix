{ config, lib, ... }:
with lib;
let
    cfg = config.services.gnome-config;
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

          environment.gnome.excludePackages = with pkgs.gnome; [
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

            gnome-calculator gnome-calendar gnome-clocks gnome-contacts
            gnome-font-viewer gnome-logs gnome-maps gnome-music gnome-photos gnome-screenshot
            gnome-system-monitor gnome-weather gnome-disk-utility pkgs.gnome-connections
          ];

          environment.systemPackages = with pkgs; [
             gtk4

             gnome.dconf-editor
             gnome.gnome-tweaks
             gnome-extension-manager

             gnomeExtensions.weather-oclock
             gnomeExtensions.open-bar
             gnomeExtensions.appindicator
             gnomeExtensions.spotify-tray
          ];

          services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    };
}