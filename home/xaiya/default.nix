{

  imports = [
    ./packages.nix # Load packages
    ./cli # CLI configurations that are so unique that they are separated into the home folders
    ./dconf.nix
  ];

  sylveon = {
    apps = {
      librewolf.enable = true;
      discord.enable = true;
    };

    cli = {
      zsh.enable = true;
      direnv.enable = true;
      git.enable = true;

      kitty.enable = true;
    };
  };

  home.stateVersion = "25.05";
}