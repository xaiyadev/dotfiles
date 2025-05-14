{

  imports = [
    ./packages.nix # Load packages
    ./cli # CLI configurations that are so unique that they are separated into the home folders
  ];

  sylveon = {
    apps.librewolf.enable = true;

    cli = {
      zsh.enable = true;
      direnv.enable = true;

      kitty.enable = true;
    };
  };
}
