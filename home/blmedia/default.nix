{ pkgs, ... }:
{

  imports = [
    ./programs
    ./cli
  ];

  sylveon = {
    profiles.user = {
      music.enable = true;
    };

    programs = {
      chromium.enable = true;
      discord.enable = true; # TODO: load only arpc?
    };
  };
}
