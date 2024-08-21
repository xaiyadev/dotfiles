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

    users.users.firefly = {
        isSystemUser = true;
        initialPassword = "firefly";
        description = "Firefly";
        extraGroups = [ "networkmanager" "firefly" ];
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
    };
  };
}