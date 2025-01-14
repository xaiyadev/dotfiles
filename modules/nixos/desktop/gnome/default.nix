{
  lib,
  pkgs,
  inputs,

  namespace,
  system,
  target,
  format,
  virtual,
  systems,

  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.gnome;
in {

  options.${namespace}.desktop.gnome = with types; {
    enable = mkBoolOpt false "Enable gnome desktop";
  };

  # For configuration and addons please visit modules/home/desktop
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

      # Enable GDM only if SDDM is not enabled anywhere else
      displayManager.gdm.enable = if (config.services.displayManager.sddm.enable == true) then false else true;
      desktopManager.gnome.enable = true;
    };

    # Remove environment Packages that I dont need for gnome
    environment.gnome.excludePackages = [
      pkgs.atomix # Puzzle Games
      pkgs.cheese # Webcam app
      pkgs.epiphany # Web browser
      pkgs.evince # Document Viewer
      pkgs.geary # Email Reader
      pkgs.gnome-music
      pkgs.gnome-photos
      pkgs.gnome-terminal
      pkgs.gnome-tour
      pkgs.hitori # soduku Game
      pkgs.iagno # poker game
      pkgs.totem # video player
    ];

    environment.systemPackages = [
      pkgs.resources # a Task-manager app
    ];
  };
}
