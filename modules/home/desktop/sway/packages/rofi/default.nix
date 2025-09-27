{
  inputs',
  pkgs,
  osConfig,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    getExe
    mkOptionDefault
    ;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  config = mkIf sway.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;

      plugins = [
        pkgs.rofi-calc
        pkgs.rofi-power-menu
      ];

      terminal = "${pkgs.kitty}/bin/kitty";
    };

    # TODO: add power-menu
  };
}
 
