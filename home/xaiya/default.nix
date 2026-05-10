{ pkgs, ... }:
{
  sylveon = {
    profiles.user = {
      gaming.enable = true;
    };

    programs = {
      chromium.enable = true;
      discord.enable = true;
    };

    packages = {
      # TODO
      inherit (pkgs.jetbrains) webstorm;
    };
  };
}
