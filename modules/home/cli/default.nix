{
  imports = [
    ./ssh.nix # SSH configurations
    ./direnv.nix # better way to manage development environment
    ./git.nix # version control

    ./zsh.nix # unix shell
    ./starship.nix
  ];
}
