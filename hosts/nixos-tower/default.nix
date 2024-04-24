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

    grub = {
      enable = true;
      device = "/dev/sda";  #  "nodev"
      efiSupport = true;
      useOSProber = true;
    };
  };

    networking = {
        networkmanager.enable = true;
        networking.hostName = "nixos-tower";

        networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
        networking.resolvconf.dnsSingleRequest = true;
    };

  system.stateVersion = "23.11";

}