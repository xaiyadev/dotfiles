{
  imports = [
    ./zsh.nix # unix shell
    ./ssh.nix # SSH configurations
    ./kitty.nix # rich terminal emulator
    ./direnv.nix # better way to manage development environment
    ./git.nix # version control
    ./neovim # vim editor configuration
  ];
}
