{ config, lib, ... }:
let
  inherit (lib) mkMerge mkIf;

  profiles = config.sylveon.profiles;
in
{

  imports = [
    ./config
    ./extraPackages.nix
  ];


  sylveon = mkMerge 
    [
      (mkIf profiles.graphical.enable {
        programs = {
          chromium.enable = true;
          discord.enable = true;
        
          anytype.enable = true;
        
          keepassxc.enable = true;
        
          music-players = [ "tidal" ];
        };
      })

      (mkIf profiles.gaming.enable {
        programs.game-clients = [ 
          "steam" 
          "bottles"
          "minecraft" 
          "deadlock"
        ];
      })
    ];
}
