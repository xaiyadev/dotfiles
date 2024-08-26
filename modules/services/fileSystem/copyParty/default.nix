{ config, lib, pkgs, copyparty, ... }:
with lib;
let
    cfg = config.services.copypartyService;
in
{
    options.services.copypartyService = {
        enable = mkEnableOption "custom copyParty service";
    };

    config = mkIf cfg.enable {
        nixpkgs.overlays = [ copyparty.overlays.default ];
        environment.systemPackages = with pkgs; [ copyparty ];

        services.copyparty = {
            enable = true;

            settings = {
                i = "0.0.0.0";
                p = [ 3210 ];

                no-reload = true;
                ignored-flag = false;
            };

            accounts = { semiko.passwordFile = ""; };

            volumes = {
                # Create a volume at "/raid" (cloud.semiko.dev/raid)
                "/raid" = {
                    # this volume points to "/mnt/raid"
                    path = "/mnt/raid/";

                    access = {
                        rw = [ "semiko" ];
                    };

                    flags = {
                        fk = 4;
                        # Time before next scan
                        scan = 60;

                        # Enables uploads to the database
                        e2d = true;
                        # Disable Multimedia parses
                        d2t = true;
                    };
                };
            };

            openFilesLimit = 8192;
        };


        networking.firewall.allowedTCPPorts = [ 3210 ];
        services.nginx.virtualHosts."cloud.semiko.dev" = {
            addSSL = true;
            enableACME = true;
            locations."/".proxyPass = "http://127.0.0.1:3210";
            extraConfig =
              # required when the target is also TLS server with multiple hosts
              "proxy_ssl_server_name on;" +
              # required when the server wants to use HTTP Authentication
              "proxy_pass_header Authorization;"
              ;
        };
    };
}