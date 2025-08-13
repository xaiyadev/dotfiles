{

  imports = [
    ./cli # CLI configurations that are so unique that they are separated into the home folders
  ];

  sylveon = {
    cli = {
      zsh.enable = true;
      direnv.enable = true;
      git.enable = true;

      neovim.enable = true;
    };
  };
}
