{ inputs, ... }: {
  imports = [
    ./desktop # Desktop specific configuration and theming
    ./apps
    ./cli

    ./home.nix
  ];
}