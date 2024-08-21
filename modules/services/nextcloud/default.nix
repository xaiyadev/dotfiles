{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.nextcloud;
in
{
    options.services.nextcloud = {
        enable = mkEnableOption "custom nextcloud service";
    };

    config = mkIf cfg.enable {

    users.users.nextcloud = {
        isSystemUser = true;
        initialPassword = "nextcloud";
        description = "Nextcloud";
        extraGroups = [ "networkmanager" "nextcloud" ];
    };


    age.secrets.postgresql.file = ../../../secrets/nextcloud.age;

    /* Nextcloud install && configuration */
    services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud29;

	    hostName = "cloud.semiko.dev";
        home = "/mnt/raid/services/netxloud/files";

        settings = {
            trusted_proxies = [
                ''nginx''
            ];

            trusted_domains = [
                ''cloud.semiko.dev''
                ''192.168.1.126:8080''
                ''10.0.0.2''
            ];

            skeletondirectory = ''/home/nextcloud/skeltonDirectory/''; /* TODO: change to: /mnt/raid/netxloud/ when RAID is installed */
            overwriteprotocol = ''https'';

            loglevel = 2;
            logtypes = ''systemd'';

            default_phone_region = ''DE'';

            "profile.enabled" = true;

        };

        # Setup Redis
        memcache.distributed = "\OC\Memcache\Redis";
        memcache.locking = "\OC\Memcache\Redis";
        filelocking.enabled = true;
        redis = {
           host = "/run/redis-nextcloud/redis.sock";
           port = 0;
        };

        /* */

        https = true;
        autoUpdateApps = {
            enable = true;
            startAt = ''Sun 14:00:00'';
        };


        database.createLocally = false;
        config = {
            adminpassFile  = config.age.secrets.firefly-app-key.path;
            adminuser = ''nextcloud'';

            dbpassFile = config.age.secrets.postgresql.path;
            dbtype = ''pgsql'';
            dbuser = ''nextcloud'';
            dbname = ''nextcloud'';

        };


        appstoreEnable = true;
        extraApps = { };

    };

    services.nginx.virtualHosts."cloud.semiko.dev" = {
        addSSL = true;
        enableACME = true;
    };


    /* Redis Configuration */
    services.redis.servers.nextcloud = {
       enable = true;
       user = "nextcloud";
       unixSocket = "/run/redis-nextcloud/redis.sock";
    };
  };
}
