{ config, lib, self, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (self.lib.modules) mkPackageOpt;

  cfg = config.sylveon.services.gitlab;

  getSecret = x: config.age.secrets."gitlab-${x}".path;

  createSecret = 
    x: y: {
      rekeyFile = "${self}/secrets/gitlab-${x}.age";
      generator.script = "${y}";

      owner = "gitlab";
      group = "gitlab";
    };

in
{

  options.sylveon.services.gitlab =
    mkPackageOpt pkgs.gitlab "Git server";

  config = mkIf cfg.enable {
    age.secrets = {
      /* Using the same password for the most thing, makes it a bit more easier to manage */
      gitlab-password = { 
        rekeyFile = "${self}/secrets/gitlab-password.age"; 

        owner = "gitlab";
        group = "gitlab";
      };

      gitlab-database-secret =
        createSecret "database-secret" "base64";

      gitlab-otp-secret =
        createSecret "otp-secret" "base64";

      gitlab-jws-secret =
        createSecret "jws-secret" "rsa";

      gitlab-record-primary-key =
        createSecret "record-primary-key" "base64";

      gitlab-record-deterministic-key =
        createSecret "record-deterministic-key" "base64";

      gitlab-salt =
        createSecret "salt" "base64";
    };

    services.postgresql = {
      ensureDatabases = [ "gitlab" ];

      ensureUsers = [{
        name = "gitlab";
        ensureDBOwnership = true;
      }];
    };

    services.gitlab = {
      enable = true;

      databaseCreateLocally = false; /* Use our postgres database */
      databaseHost = "";
      
      databasePasswordFile = getSecret "password";
      initialRootPasswordFile = getSecret "password";

      secrets = {
        secretFile = getSecret "database-secret";
        dbFile = getSecret "database-secret";

        otpFile = getSecret "otp-secret";
        jwsFile = getSecret "jws-secret";
        activeRecordPrimaryKeyFile = getSecret "record-primary-key";
        activeRecordDeterministicKeyFile = getSecret "record-deterministic-key";
        activeRecordSaltFile = getSecret "salt";
      };

      port = 8001;
    };

    services.openssh.enable = true; # TODO
    systemd.services.gitlab-backup.environment.BACKUP = "dump";

    services.nginx.virtualHosts."git.xaiya.dev" = {
      enableACME = true;
      forceSSL = true;

      locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
      extraConfig = "proxy_ssl_server_name on;";
    };
  };

}
