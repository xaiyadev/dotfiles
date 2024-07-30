{ config, pkgs, catppuccin, ... }:

{
  imports =
    [
      ../../modules/core/network
      ../../modules/core/locale
      ../../modules/core/ssh
      ../../modules/core/zsh
	
      ../../modules/core/virtualization/docker
      ../../modules/core/boot/loader/grub
      ../../modules/core/desktop/environment/gnome

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    catppuccin.flavor = "mocha";


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
    services.gnome.enable = true;

    services.zsh.enable = true;
    services.ssh.enable = true;
    services.network = {
        enable = true;
        hostName = "nixos-laptop";
    };

    services.docker.enable = true;

    environment.systemPackages = with pkgs; [
        vim
        wget
        nodejs

	devenv
    ];

    system.stateVersion = "23.11";
}
