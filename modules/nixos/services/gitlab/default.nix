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
    cfg = config.${namespace}.services.postgres;
in
{
    options.${namespace}.services.postgres = with types; {
        enable = mkBoolOpt false "Selfhosted git Server (mostly for syncing settings)";
    };

    config = mkIf cfg.enable {
      age.secrets = {
        gitlab-pwd = {
          rekeyFile = "${inputs.self}/secrets/gitlab.pwd.age";

          # Set read permissions
          owner = "root";
          group = config.services.gitlab.group;
          mode = "0440";
        };

        gitlab-secret = {
          rekeyFile = "${inputs.self}/secrets/gitlab.secret.age";

          # Set read permissions for firefly
          owner = "root";
          group = config.services.gitlab.group;
          mode = "0440";
        };

        gitlab-otp = {
          rekeyFile = "${inputs.self}/secrets/gitlab.otp.age";

          # Set read permissions for firefly
          owner = "root";
          group = config.services.gitlab.group;
          mode = "0440";
        };

        gitlab-jws = {
          rekeyFile = "${inputs.self}/secrets/gitlab.jws.age";

          # Set read permissions for firefly
          owner = "root";
          group = config.services.gitlab.group;
          mode = "0440";
        };
      };

      services.gitlab = {
        enable = true;

        initialRootPasswordFile = config.age.secrets.gitlab-pwd.path;

        databaseHost = "/run/postgresql";
        databaseName = config.service.gitlab.user;
        databaseUser = config.services.gitlab.user;

        secrets = {
          secretFile = config.age.secrets.gitlab-secrets.path;
          otpFile = config.age.secrets.gitlab-otp.path;
          jwsFile = config.age.secrets.gitlab-jws.path;

        };

      };
    };
}
