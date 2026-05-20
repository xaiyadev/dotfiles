{ pkgs, ... }:
{

  imports = [
    ./programs
  ];

  sylveon = {
    profiles.user = {
      gaming.enable = true;
      music.enable = true;
    };

    programs = {
      chromium.enable = true;
      discord.enable = true;
    };
  };
}
