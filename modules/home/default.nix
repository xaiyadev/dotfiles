{ inputs, ... }: {
  imports = [
    inputs.nixcord.homeModules.nixcord

    ./desktop # Desktop specific configuration and theming
    ./apps
    ./cli

    ./home.nix
  ];
}