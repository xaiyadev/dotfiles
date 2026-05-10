{ pkgs, ... }:
{

  imports = [
    ./programs
  ];

  config = {
    sylveon = {
      programs = {
        chromium.enable = true;
        discord.enable = true;
      };

      packages = {
        # TODO
        inherit (pkgs.jetbrains) phpstorm;
      };
    };
  };
}
