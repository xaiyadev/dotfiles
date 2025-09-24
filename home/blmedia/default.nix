{

  imports = [
    ./packages.nix # Load packages
    ./cli # CLI configurations that are so unique that they are separated into the home folders
  ];

  sylveon = {
    programs = {
      librewolf.enable = true;
      discord.enable = true;
    };

    cli = {
      zsh.enable = true;
      direnv.enable = true;
      git.enable = true;

      neovim = {
        enable = true;
        anonymous = true;
      };
      kitty.enable = true;
    };
  };
}
