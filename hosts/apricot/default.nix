{ config, pkgs, catppuccin, inputs, ... }:

{
  imports =
    [
      ../../modules/core/network
      ../../modules/core/locale
      ../../modules/core/ssh
      ../../modules/core/zsh

      ../../modules/services/adminerevo
      ../../modules/services/nextcloud

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


    /* Enable NGINX */
    services.nginx.enable = true;
    services.nginx.virtualHosts."cloud.semiko.dev" = {
        addSSL = true;
        enableACME = true;
    };

    security.acme = {
        acceptTerms = true;
        defaults.emal = "danil80sch@gmail.com";
    };

    /* --- */

    /* Enable Database */
    services.postgresql = {
      enable = true;
      ensureUsers = [
        { name = "nextcloud"; ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES"; }
        { name = "firefly"; }
      ];
      ensureDatabases = [ "nextcloud" "firefly" ];
    };


    /* Enable Custom Services */
    services.nextcloud.enable = true;
    services.adminerevo.enable = true;
    services.firefly.enable = true;

    /* Default Settings Services */
    services.locale.enable = true;
    hardware.pulseaudio.enable = true;
    services.grub.enable = true;


    services.zsh.enable = true;
    services.ssh.enable = true;
    services.network = {
        enable = true;
        hostName = "apricot";
    };

    environment.systemPackages = with pkgs; [
        vim
        wget
        nodejs

        inputs.agenix.packages."${system}".default
    ];

    system.stateVersion = "23.11";
}
