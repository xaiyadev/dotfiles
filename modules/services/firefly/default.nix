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
          home = "/home/firefly/";  /* home = "/mnt/raid/services/firefly/"; TODO: change when RAID installed */

      };

      services.firefly-iii = {
        enable = true;
        enableNginx = true;
        group = "firefly";
        user = "firefly";

        settings = {
            APP_ENV= "production";
            SITE_OWNER = "danil80sch@gmail.com";
            APP_KEY_FILE = "./SECRET.txt"; # TODO:
            DEFAULT_LANGUAGE="en_US";
            TRUSTED_PROXIES="**";

            DB_CONNECTION="pgsql";
            DB_HOST="/run/postgresql";
            DB_PORT="5432";
            DB_DATABASE="firefly";
            DB_USERNAME="firefly";
            DB_PASSWORD="password"; # TODO: LEARN AGE! PLEASE

        };
      };
  };
}