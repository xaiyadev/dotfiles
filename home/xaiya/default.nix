{ pkgs, ... }:
{
  sylveon = {
    programs = {
      librewolf.enable = true;

      # discord.enable = true; TODO
    };

    packages = {
      # TODO
      inherit (pkgs.jetbrains) webstorm;
    };
  };

  programs.discord.enable = true;
}
