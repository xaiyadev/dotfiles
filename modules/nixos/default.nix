{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager # TODO: Temporary
    inputs.stylix.nixosModules.stylix

    ./boot # Boot configuration and loader
    ./graphical
    ./hardware
    ./nix
    ./environment

    ./users.nix # load and create users
    ./extraPackages.nix
  ];
}