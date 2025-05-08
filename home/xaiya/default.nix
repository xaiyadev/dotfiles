{

  imports = [
    ./packages.nix # Load packages
  ];

  sylveon = {
    apps = {
      librewolf.enable = true;
      discord.enable = true;
    };
  };
}