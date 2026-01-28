{

  imports = [
    ./packages.nix # Load packages
  ];

  sylveon = {
    programs = {
      librewolf.enable = true;
      discord.enable = true;

      jetbrains.webstorm.enable = true;
    };

    tui.neovim.enable = true;
  };
}
