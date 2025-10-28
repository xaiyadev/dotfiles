{ lib, osConfig, pkgs, ... }:

let
  inherit (lib)
    mkIf
    getExe
    ;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  imports = [
    ./docked_home.nix
    ./docked_office.nix
  ];

  config = mkIf sway.enable {
    services.kanshi = {
      enable = true;

      # global outputs
      settings = [
        # Internal screen disabled
        {
          output = {
            alias = "disabled_internal";

            criteria = "eDP-2";
            status = "disable";
          };
        }

        # Internal screen enabled
        {
          output = {
            alias = "enabled_internal";

            criteria = "eDP-2";
            mode = "2560x1600@165.000Hz";
          };
        }


        # Configuration if only single display is loaded
       {
        profile = {
          name = "standalone";
          exec = "${getExe pkgs.brightnessctl} set 68%";

          outputs = [{ criteria = "$enabled_internal"; }];
        };
       }
      ];
    };
  };
}
