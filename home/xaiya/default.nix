{

  imports = [
    ./packages.nix # Load packages
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

      neovim = {
        enable = true;
        anonymous = false;
      };

      kitty.enable = true;
    };
  };
}
