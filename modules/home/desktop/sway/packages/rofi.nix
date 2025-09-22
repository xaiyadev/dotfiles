{
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
    ;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  config = {
    programs.rofi = mkIf sway.enable {
      enable = true;
      package = pkgs.rofi;

      # Only working when calling rofi from the terminal right now
      # Refer to https://discourse.nixos.org/t/rofi-on-wayland-and-plugins/17354/8
      modes = [
        "drun"
        # "ssh"
        {
          name = "power";
          path = getExe pkgs.rofi-power-menu;
        }
      ];

      plugins = [
        pkgs.rofi-power-menu
      ];

      terminal = "${pkgs.kitty}/bin/kitty";
    };

    wayland.windowManager.sway.config.menu = ''${config.programs.rofi.finalPackage}/bin/rofi -show-icons -show combi'';
  };
}
 
