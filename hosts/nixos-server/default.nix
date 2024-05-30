{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/system.nix

      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
  };

    networking = {
        hostName = "nixos-server";
        networkmanager.enable = true;

        nameservers = [ "1.1.1.1" "8.8.8.8" ];
        resolvconf.dnsSingleRequest = true;
    };

  system.stateVersion = "23.11";

}
