{ config, pkgs, catppuccin, inputs, ... }:

{
  imports =
    [
      ../../modules/core/network
      ../../modules/core/locale
      ../../modules/core/ssh
      ../../modules/core/zsh

      ../../modules/core/boot/loader/grub
      ../../modules/core/boot/loader/kodi


      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    # Steam workign settings
    hardware.opengl.driSupport32Bit = true;

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
    services.kodi.enable = true;

    services.zsh.enable = true;
    services.ssh.enable = true;
    services.network = {
        enable = true;
        hostName = "pineapple";
    };

    services.docker.enable = true;

    environment.systemPackages = with pkgs; [
        vim
        wget
        nodejs
	    devenv

        inputs.agenix.packages."${system}".default
    ];

    virtualisation.libvirtd.enable = true;

    system.stateVersion = "23.11";
}
