{

  imports = [
    ./packages.nix # Load packages
  ];

  sylveon = {
    programs = {
      librewolf.enable = true;
      discord.enable = true;
      lutris.enable = true;

      jetbrains.webstorm.enable = true;
    };

    cli.neovim.enable = true;
  };
}
