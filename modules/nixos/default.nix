{ inputs, self, ... }: {
  imports = [
    ./boot # Boot configuration and loader
    ./graphical
    ./hardware
    ./nix
    ./environment
    ./security

    ./themes.nix
    ./env.nix
    ./users.nix # load and create users
    ./extraPackages.nix
  ];

}
