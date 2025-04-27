{
  imports = [
    ./boot # Boot configuration and loader
    ./graphical
    ./users.nix # load and create users
    ./power.nix
  ];
}