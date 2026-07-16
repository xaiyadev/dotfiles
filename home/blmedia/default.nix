{ ... }:
{

  imports = [
    ./programs
    ./cli
  ];

  sylveon = {
    programs = {
      chromium.enable = true;
      discord.enable = true;

      neovim.enable = true;

      music-players = [ "spotify" ];
    };
  };
}
