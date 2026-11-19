{ lib, osConfig, pkgs, ... }:

let
  inherit (lib)
    mkIf
    ;

  inherit (osConfig.sylveon.graphical) sway;
in
{
  config = mkIf sway.enable {
    programs.quickshell = {
      enable = true;

      package = pkgs.symlinkJoin {
        name = "wrapped-quickshell";
        paths = [
          pkgs.quickshell
          pkgs.adwaita-icon-theme # icon theme for app and tray icons, see shell.qml
          pkgs.material-symbols # icon font, see Theme.iconFont
          pkgs.nerd-fonts.jetbrains-mono # see Theme.font
          pkgs.sound-theme-freedesktop # toast sound, see Config.notificationSound
          pkgs.networkmanagerapplet # nm-connection-editor
        ];

        meta.mainProgram = pkgs.quickshell.meta.mainProgram;
      };
    };

    # get the quickshell configuration into the config directory
    xdg.configFile."quickshell".source = ./config;
  };
}
