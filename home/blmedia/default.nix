{ pkgs, ... }:
{

  imports = [
    ./programs
    ./cli
  ];

  config = {
    sylveon = {
      programs = {
        chromium.enable = true;
        discord.enable = true; # TODO: load only arpc?
      };
    };
  };
}
