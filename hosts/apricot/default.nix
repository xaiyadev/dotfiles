{ config, pkgs, catppuccin, inputs, ... }:

{
    imports =
    [
      ../../modules/core/network
      ../../modules/core/locale
      ../../modules/core/ssh
      ../../modules/core/zsh

      ../../modules/services/adminerevo
      ../../modules/services/fileSystem/syncthing
      ../../modules/services/firefly
      ../../modules/services/soft-serve
      ../../modules/services/homepage
      ../../modules/services/mail
      ../../modules/services/plex
      ../../modules/services/vaultwarden

      ../../modules/core/virtualization/docker
      ../../modules/core/boot/loader/grub

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    # Load all age Keys
    age.secrets = {
        cloudflare.file = ../../secrets/cloudflare.env.age;

        firefly.file     = ../../secrets/firefly.env.age;
        vaultwarden.file = ../../secrets/vaultwarden.env.age;
        soft-serve.file  = ../../secrets/soft-serve.env.age;

    };

    environment.systemPackages = with pkgs; [
        vim
        wget
        nodejs
    ];

    nix.settings = {
        substituters = [ "https://ezkea.cachix.org" ];
        trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];

        trusted-users = [ "root" "semiko" ];
        experimental-features = [ "nix-command" "flakes" ];
    };
    nixpkgs.config.allowUnfree = true;

    services.zsh.enable = true;
    services.ssh.enable = true;

    services.network = {
        enable = true;
        hostName = "apricot";
    };

    networking.defaultGateway6 = { address = "fe80::1"; interface = "eno1"; };

    /* Default Settings Services */
    services.locale.enable = true;
    hardware.pulseaudio.enable = true;
    services.grub.enable = true;


    /* Enable NGINX */
    services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
    };

    security.acme = {
        acceptTerms = true;
        defaults.email = "danil80sch@gmail.com";
        certs."semiko.dev" = {
            domain = "*.semiko.dev";
            dnsProvider = "cloudflare";

            group = "nginx";
            environmentFile = config.age.secrets.cloudflare.path;
        };
    };

    /* --- */

    networking.firewall.allowedTCPPorts = [ 80 443 ];
    /* Enable Custom Services */

    services.docker.enable = true;
    services.vaultwardenService = {
        enable = true;
        asDockerContainer = true;
    };

    services.firefly = {
        enable = true;
        asDockerContainer = true;
    };

    services.syncthingService = {
        enable = true;
        asDockerContainer = true;
    };


    services.homepage.enable = true;

    # services.plex.enable = true;



    system.stateVersion = "23.11";
}
