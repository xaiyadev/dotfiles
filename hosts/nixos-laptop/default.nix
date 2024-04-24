{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/system.nix
      ../../modules/gnome

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

    networking = {
        hostName = "nixos-laptop";
        networkmanager.enable = true;

        nameservers = [ "1.1.1.1" "8.8.8.8" ];
        resolvconf.dnsSingleRequest = true;
    };

  system.stateVersion = "23.11";

}