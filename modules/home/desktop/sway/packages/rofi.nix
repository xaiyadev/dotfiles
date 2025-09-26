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
    forEach
    getExe
    mkOptionDefault
    ;

  inherit (lib.strings)
    concatStringsSep
    ;

  sway = osConfig.sylveon.system.graphical.sway;
  modifier = config.wayland.windowManager.sway.config.modifier;
in
{

  config = mkIf sway.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;

      modes = [
        "drun"
        {
          name = "power";
          path = (getExe pkgs.rofi-power-menu);
        }
      ];

      plugins = [
        pkgs.rofi-calc
      ];

      terminal = "${pkgs.kitty}/bin/kitty";
    };

    wayland.windowManager.sway.config.keybindings = mkOptionDefault {
      "${modifier}+c" = ''exec ${config.programs.rofi.finalPackage}/bin/rofi -show calc'';
    };

    
    # Application selector
    wayland.windowManager.sway.config.menu = concatStringsSep ''\'' [
      ''${config.programs.rofi.finalPackage}/bin/rofi ''

      ''-combi-modi "${
        concatStringsSep 
          '','' 
          (forEach config.programs.rofi.modes (x: if (builtins.typeOf x == "string") then x else x.name))
      }" ''

      ''-show-icons ''
      ''-show combi ''
    ];
  };
}
 
