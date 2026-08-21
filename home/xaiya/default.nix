{ ... }:
{

  imports = [
    ./programs
  ];

  sylveon = {
    profiles.user = {
      gaming.enable = true;
    };

    programs = {
      chromium.enable = true;
      discord.enable = true;

      keepassxc.enable = true;

      neovim.enable = true;

      music-players = [ "tidal" ];
    };
  };
}
