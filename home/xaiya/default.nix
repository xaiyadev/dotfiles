{

  imports = [
    ./packages.nix # Load packages
    ./cli # CLI configurations that are so unique that they are separated into the home folders
  ];

  sylveon = {
    programs = {
      librewolf.enable = true;
      discord.enable = true; # TODO: https://github.com/KaylorBen/nixcord/issues/114

      lutris.enable = true; # Game Launcher
    };

    cli = {
      zsh.enable = true;
      direnv.enable = true;
      git.enable = true;

      neovim.enable = true;
      kitty.enable = true;
    };
  };
}
