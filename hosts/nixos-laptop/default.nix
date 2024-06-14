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
    programs.virt-manager.enable = true;

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
        firewall.enable = true;

        hostName = "nixos-laptop";
        networkmanager.enable = true;

        nameservers = [ "1.1.1.1" "8.8.8.8" ];
        resolvconf.dnsSingleRequest = true;
    };

    hardware = {
        opengl.driSupport32Bit = true;
        xpadneo.enable = true;
    };




  system.stateVersion = "23.11";

}
