{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager # TODO: Temporary
    inputs.stylix.nixosModules.stylix
    inputs.agenix.nixosModules.default



    ./boot # Boot configuration and loader
    ./graphical
    ./hardware
    ./nix
    ./environment
    ./security

    ./users.nix # load and create users
    ./extraPackages.nix
  ];
}