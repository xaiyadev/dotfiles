{ ... }:
{

  imports = [
    ./config
    ./extraPackages.nix
  ];

  sylveon = {
    programs = {
      chromium.enable = true;
      discord.enable = true;

      anytype.enable = true;

      keepassxc.enable = true;

      music-players = [ "tidal" ];
    };
  };
}
