{ ... }:
{

  imports = [
    ./config
    ./extraPackages.nix
  ];

  sylveon = {
    profiles.user = {
      gaming.enable = true;
    };

    programs = {
      chromium.enable = true;
      discord.enable = true;

      anytype.enable = true;

      keepassxc.enable = true;

      music-players = [ "tidal" ];

      game-clients = [ 
        "steam" 
        "bottles"
        "minecraft" 
        "deadlock"
      ];
    };
  };
}
