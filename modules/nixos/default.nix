{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager # TODO: Temporary
    inputs.stylix.nixosModules.stylix

    ./boot # Boot configuration and loader
    ./graphical
    ./users.nix # load and create users
    ./power.nix
  ];
}