{ inputs, ... }:
{
  imports = [
    ./desktop # Desktop specific configuration and theming
    ./programs
    ./cli

    ./home.nix
  ];
}
