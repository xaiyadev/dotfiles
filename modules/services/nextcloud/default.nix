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
        isNormalUser = true;
        initialPassword = "nextcloud";
        description = "Danil Schumin";
        extraGroups = [ "networkmanager" "wheel" "nextcloud" ];
    };


    /* TODO: add redis! */
    services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud29;

        home = ''/home/nextcloud/files/'';

        settings = {
            trusted_proxies = [
                ''nginx''
            ];

            trusted_domains = [
                ''cloud.semiko.dev''
                ''192.168.1.126:8080''
                ''10.0.0.2''
            ];

            skeletondirectory = ''/home/nextcloud/skeltonDirectory/'';
            overwriteprotocol = ''https'';

           /* Log Levels
            * 0 (debug): Log all activity.
            *
            *  1 (info): Log activity such as user logins and file activities, plus warnings, errors, and fatal errors.
            *
            *  2 (warn): Log successful operations, as well as warnings of potential problems, errors and fatal errors.
            *
            *  3 (error): Log failed operations and fatal errors.
            *
            *  4 (fatal): Log only fatal errors that cause the server to stop.
            */
            loglevel = 2;
            logtypes = ''systemd'';

            default_phone_region = ''DE'';

            "profile.enabled" = true;

        };
        https = true;

        autoUpdateApps = {
            enable = true;
            startAt = ''Sun 14:00:00'';
        };


        database.createLocally = true;
        config = {
            adminpassFile  = ''/find/good/position/to/save''; /* TODO */
            adminuser = ''nextcloud'';

            dbpassFile = ''/find/good/position/to/save'' /* TODO */;
            dbtype = ''pgsql'';
            dbuser = ''nextcloud'';
            dbname = ''nextcloud'';

        };


        appstoreEnable = true; /* TODO: false when extra Apps got apps added */
        extraApps = {
        /* TODO: Add Apps! :3 */

        };

        phpExtraExtensions = all: [
            /* Used for settings.log_types */
            php-systemd
        ];

    };
  };
}