{ config, pkgs, ... }:
{
  imports = [
  ../../modules/system.nix
  ../../modules/gnome

/*
  ../../modules/Filesystem/RAID
*/

  ../../modules/chromium
  ../../modules/obsidian

  # Include the results of the hardware scan.
  ./hardware-configuration.nix
  ];
  programs.virt-manager.enable = true;

  # Bootloader.
  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader = {
    efi.canTouchEfiVariables = true;

        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
        };
    };

    networking = {
        firewall.enable = true;

        hostName = "nixos-tower";
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
