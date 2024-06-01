{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/system.nix
      ../../modules/gnome

      ../../modules/chromium
      ../../modules/obsidian

      # Include the results of the hardware scan.
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
        hostName = "nixos-laptop";
        networkmanager.enable = true;

        nameservers = [ "1.1.1.1" "8.8.8.8" ];
        resolvconf.dnsSingleRequest = true;
    };


  programs.virt-manager.enable = true;

  system.stateVersion = "23.11";

}
