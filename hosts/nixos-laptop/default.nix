{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/core/network
      ../../modules/core/locale
      ../../modules/core/ssh
      ../../modules/core/zsh
      ../../modules/core/boot/loader/grub

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    services.locale.enable = true;
    hardware.pulseaudio.enable = true;
    services.grub.enable = true;

    services.zsh.enable = true;
    services.ssh.enable = true;
    services.network = {
        enable = true;
        hostName = "nixos-laptop";
    };

    environment.systemPackages = with pkgs; [
        vim
        wget
        nodejs
    ];

    system.stateVersion = "23.11";
}