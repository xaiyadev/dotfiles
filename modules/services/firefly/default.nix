{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.firefly;
in
{
    options.services.firefly = {
        enable = mkEnableOption "custom firefly service";
    };

    config = mkIf cfg.enable {

    users.groups.firefly = {};
    users.users.firefly = {
        isSystemUser = true;
        initialPassword = "firefly";
        description = "Firefly";
        extraGroups = [ "networkmanager" ];
        group = "firefly"; # Firefly requirs you to add this group this way
    };


    services.firefly-iii = {
        enable = true;
        enableNginx = true;
        #dataDir = "/mnt/raid/services/firefly/";
        group = "firefly";
        user = "firefly";

        settings = {
            APP_ENV= "production";
            SITE_OWNER = "danil80sch@gmail.com";
            APP_KEY_FILE = config.age.secrets.firefly.path;
            DEFAULT_LANGUAGE="de_DE";
            TRUSTED_PROXIES="**";

            DB_CONNECTION="pgsql";
            DB_DATABASE="firefly";
            DB_HOST="/run/postgresql";
            DB_PORT = 5432;
        };
    };

    services.nginx.virtualHosts."cash.semiko.dev" = {
        forceSSL = true;
        useACMEHost = "semiko.dev";
        locations."/".proxyPass = "http://[::1]:8080";
        extraConfig = "proxy_ssl_server_name on;";
    };
  };
}