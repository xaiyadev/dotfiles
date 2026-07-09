{ ... }:
{

  imports = [
    ./programs
    ./cli
  ];

  sylveon = {
    programs = {
      chromium.enable = true;
      discord.enable = true; # TODO: load only arpc?

      music-players = [ "spotify" ];
    };
  };
}
