{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.lists) any;

  clients = config.sylveon.programs.game-clients;
in
{
  config = mkIf (clients != null && any (x: x == "steam") clients) {
    sylveon.packages = {
      inherit (pkgs) gamescope;

      # Every game that is started on steam uses the external GPU ( TODO: framework only?)
      steam = pkgs.steam.override { 
        extraEnv = { 
          DRI_PRIME = "1"; 
          MANGOHUD = "1";
        }; 

        # this is a function..
        extraPkgs = _: [ config.programs.mangohud.package ];
      };
    };

    programs.mangohud = {
      enable = true;
      settings = {
        fps_limit = 144;
        toggle_fps_limit = "Shift_R+F1";

        no_display = true; # hide mangohud overlay by default
        toggle_hud = "Shift_R+F12";

        frametime = true;
        cpu_temp = true;
        gpu_temp = true;
        cpu_power = true;
        gpu_power = true;
      };
    };
  };
}
