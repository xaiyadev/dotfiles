{

  imports = [
    ./packages.nix # Load packages
    ./config # extra configuration just for this user
  ];

  sylveon = {
    programs = {
      librewolf.enable = true;
      discord.enable = true;

      jetbrains.phpstorm.enable = true;
    };

    tui = {
      neovim = {
        enable = true;
        anonymous = true;
      };
    };
  };
}
