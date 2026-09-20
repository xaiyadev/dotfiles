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

      # install quickshell package with extra icon dependencies
      package = pkgs.symlinkJoin {
        name = "wrapped-quickshell";
        paths = [
          pkgs.quickshell
          pkgs.adwaita-icon-theme
        ];

        meta.mainProgram = pkgs.quickshell.meta.mainProgram;
      };
    };

    # get the quickshell configuration into the config directory
    xdg.configFile."quickshell".source = ./config;
  };
}
