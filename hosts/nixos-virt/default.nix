{ config, pkgs, catppuccin, ... }:

{
  imports =
    [
      ../../modules/core/network
      ../../modules/core/locale
      ../../modules/core/ssh
      ../../modules/core/zsh

      ../../modules/services/adminerevo
      ../../modules/services/nextcloud
      ../../modules/services/postgreSQL

      ../../modules/core/virtualization/docker
      ../../modules/core/boot/loader/grub

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    nix.settings = {
        substituters = [ "https://ezkea.cachix.org" ];
        trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];

        trusted-users = [ "root" "semiko" ];
        experimental-features = [ "nix-command" "flakes" ];
    };


    nixpkgs.config.allowUnfree = true;

    services.locale.enable = true;
    hardware.pulseaudio.enable = true;
    services.grub.enable = true;

    services.postgreSQL.enable = true;
    services.nextcloudCustom.enable = true;
    services.adminerevo.enable = true;

    services.zsh.enable = true;
    services.ssh.enable = true;
    services.network = {
        enable = true;
        hostName = "nixos-virt";
    };

    services.docker.enable = true;

    environment.systemPackages = with pkgs; [
        vim
        wget
        nodejs

	    devenv
    ];


    virtualisation.libvirtd.enable = true;

    system.stateVersion = "23.11";
}
