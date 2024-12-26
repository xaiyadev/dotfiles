{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  specialArgs,
  ...
}:
with lib;
with lib.${namespace};
let
    cfg = config.${namespace}.services.gitlab;
in
{
    options.${namespace}.services.gitlab = with types; {
        enable = mkBoolOpt false "Selfhosted git Server (mostly for syncing settings)";
    };

    config = mkIf cfg.enable {
      age.secrets = {

        gitlab-pwd = {
          rekeyFile = "${inputs.self}/secrets/gitlab.pwd.age";
          generator.script = "passphrase"; # TODO: create script that creates the password and adds it to bitwarden

          group = config.services.gitlab.group;
          mode = "0440";
        };

        gitlab-secret = {
          rekeyFile = "${inputs.self}/secrets/gitlab.secret.age";
          generator.script = "alnum";

          group = config.services.gitlab.group;
          mode = "0440";

        };

        gitlab-otp = {
          rekeyFile = "${inputs.self}/secrets/gitlab.otp.age";
          generator.script = "alnum";

          group = config.services.gitlab.group;
          mode = "0440";
        };


        gitlab-db-secret = {
          rekeyFile = "${inputs.self}/secrets/gitlab.db-secret.age";
          generator.script = "alnum";


          group = config.services.gitlab.group;
          mode = "0440";
        };

        gitlab-jws = {
          rekeyFile = "${inputs.self}/secrets/gitlab.jws.age";
          generator.script = "jws";

          group = config.services.gitlab.group;
          mode = "0440";
        };
      };

      # Generate database
      services.postgresql = {
        ensureDatabases = [ config.services.gitlab.user ];
        ensureUsers = [{
            name = config.services.gitlab.user;
            ensureDBOwnership = true;
        }];
      };

      services.gitlab = {
        enable = true;
        https = true;

        initialRootPasswordFile = config.age.secrets.gitlab-pwd.path;

        databaseName = config.services.gitlab.user;
        databaseUsername = config.services.gitlab.user;


        secrets = {
          secretFile = config.age.secrets.gitlab-secret.path;
          otpFile = config.age.secrets.gitlab-otp.path;
          dbFile = config.age.secrets.gitlab-db-secret.path;
          jwsFile = config.age.secrets.gitlab-jws.path;

        };

      };

      # Setup backup configuration
      systemd.services.gitlab-backup.environment.BACKUP = "dump";

      services.nginx.virtualHosts."git.xaiya.dev" = {
        locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
      };
    };
}
