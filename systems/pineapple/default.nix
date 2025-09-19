{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ./fileSystem.nix
  ];

  networking.hostName = "pineapple";

  boot.extraModulePackages = [ config.boot.kernelPackages.xpadneo ];

  sylveon = {
    profiles = {
      graphical.enable = true;
      gaming.enable = true;
      laptop.enable = true;
    };

    device = {
      cpu = "amd";
      gpu = "amd";
    };

    system = {
      users = [
        "xaiya"
        "blmedia"
      ];
    };

    services = {
      docker.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
