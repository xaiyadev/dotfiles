{ config, lib, self, ... }:
let
  inherit (lib) 
    forEach
    mkMerge
    mkIf
    ;

  inherit (builtins)
    elemAt
    toString
    ;
in
{
  wayland.windowManager.sway.config = {
    # Configure wallpaper
    output."*" = {
      bg = "${self}/assets/wallpaper/flamingo_bkg5.png fill";
    };
    defaultWorkspace = "1";

    workspaceOutputAssign = mkMerge [

      # Automated generated outputs with the help of kanshi
      # TODO: this *can* have double outputs, not imediatly bad but can hurt the config
      (mkIf config.services.kanshi.enable (forEach [1 2] (x: {
        output = 
          forEach config.services.kanshi.settings (y: (
            (elemAt y.profile.outputs (x - 1)).criteria)
          );

        # Assign the 10 workspaces we have
        workspace = toString x;
      })))
      
      [
        {
          output = [ "eDP-2" ];
          workspace = "3";
        }
        
        {
          output = [ "eDP-2" ];
          workspace = "4";
        }
      ]
    ];
  };
}
