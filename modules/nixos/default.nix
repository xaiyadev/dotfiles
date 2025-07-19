{ inputs, self, ... }: {
  imports = [
    ./boot # Boot configuration and loader
    ./graphical
    ./hardware
    ./nix
    ./environment
    ./security
    ./system

    ./users.nix # load and create users
    ./extraPackages.nix
  ];

}
