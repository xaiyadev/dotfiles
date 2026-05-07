{
  imports = [
    ./age # secret files management
    ./pam.nix # login fluff
    ./gpg.nix # signing fluff
    ./sudo.nix # set up sudo configuration
  ];
}
