{ lib, self, config, pkgs, ... }:
let
  inherit (lib.modules) mkIf;
  inherit (lib.types) listOf package;


  inherit (self.lib.modules) mkOpt;
  windowManagers = config.sylveon.system.graphical.windowManagers;
  cfg = config.sylveon.system.graphical.gnome;
in
{

  options.sylveon.system.graphical.gnome = {
    excludedPackages = mkOpt (listOf (package)) [ ] "Extra packages that should be excluded from the gnome environment";
  };

  config = mkIf (builtins.elem "gnome" windowManagers) {
    services.xserver.desktopManager.gnome.enable = true;

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
      pkgs.gnome-system-monitor # replaced by resources
    ] ++ cfg.excludedPackages;

    environment.systemPackages = [
      pkgs.resources # System monitor, but cuter
    ];

    #
    services.udev.extraRules = ''
      ACTION=="remove",\
       ENV{ID_BUS}=="usb",\
       ENV{ID_MODEL_ID}=="0407",\
       ENV{ID_VENDOR_ID}=="1050",\
       ENV{ID_VENDOR}=="Yubico",\
       RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';
  };

}
