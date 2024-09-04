{ config, pkgs, catppuccin, inputs, ... }:

{
    imports =
    [
      ../../modules/core/network
      ../../modules/core/locale
      ../../modules/core/ssh
      ../../modules/core/zsh

      ../../modules/services/adminerevo
      ../../modules/services/fileSystem/copyParty
      ../../modules/services/fileSystem/syncthing
      ../../modules/services/firefly
      ../../modules/services/git
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
        postgresql.file = ../../secrets/postgresql.age;
        cloudflare.file = ../../secrets/cloudflare.age;

        firefly.file    = ../../secrets/firefly.env.age;
        vaultwarden.file    = ../../secrets/vaultwarden.env.age;

        copyparty-semiko = {
            file = ../../secrets/copyparty-semiko.age;
            owner = "copyparty";
        };

        copyparty-sergej = {
            file = ../../secrets/copyparty-sergej.age;
            owner = "copyparty";
        };
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

    /* Enable Database */

    # TODO: Add Functional Postgres Database when Passwords are save
/*    services.postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" "firefly" "vaultwarden" ];
    };*/

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    /* Enable Custom Services */

    services.docker.enable = true;


    # TODO: fix these Services ALL WEB NOT WORKING GOD DAAAMAMN
    services.vaultwardenService = {
        enable = true;
        asDockerContainer = true;
    };

    # TODO: Needs fix.
    /*services.firefly = {
        enable = true;
        asDockerContainer = true;
    };*/

    services.syncthingService = {
        enable = true;
        asDockerContainer = true;
    };

    services.copypartyService.enable = true;
    services.homepage.enable = true;

    # services.plex.enable = true;
    #services.adminerevo.enable = true;
    #services.soft-serve.enable = true;




    system.stateVersion = "23.11";
}
