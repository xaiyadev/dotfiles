{ inputs, self, ... }: {
  imports = [
    ./hardware
    ./nix
    ./environment
    ./security
    ./system

    ./users.nix # load and create users
    ./extraPackages.nix
  ];

}
