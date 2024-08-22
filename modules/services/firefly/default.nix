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

    age.secrets.firefly.file = ../../../secrets/firefly-app-key.age;

    services.firefly-iii = {
        enable = true;
        enableNginx = true;
        # dataDir = "/mnt/raid/services/firefly/";
        group = "firefly";
        user = "firefly";

        settings = {
            APP_ENV= "production";
            SITE_OWNER = "danil80sch@gmail.com";
            APP_KEY_FILE = config.age.secrets.firefly-app-key.path;
            DEFAULT_LANGUAGE="en_US";
            TRUSTED_PROXIES="**";

            DB_CONNECTION="pgsql";
            DB_PORT="5432";
            DB_DATABASE="firefly";
            DB_USERNAME="firefly";
            DB_PASSWORD_FILE = config.age.secrets.postgresql.path;
        };
    };

    services.nginx.virtualHosts."cash.semiko.dev" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://127.0.0.1:8080";
        extraConfig =
          # required when the target is also TLS server with multiple hosts
          "proxy_ssl_server_name on;" +
          # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;"
          ;
    };
  };
}