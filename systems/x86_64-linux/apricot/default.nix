{
  lib,
  pkgs,
  inputs,

  namespace,
  system,
  target,
  format,
  virtual,
  systems,

  config,
  ...

}:
with lib;
with lib.${namespace};
{
  imports = [ ./hardware.nix ];

  /* System specific configurations */
  networking.hostName = "apricot";

  ${namespace} = {
    nix = { enable = true; lix = enabled; };
    # no desktop environment needed, its a server ¯\_(ツ)_/¯

    system = {
      boot = enabled;
      ssh = enabled;
      zsh = enabled;

      fonts = enabled;
      locale = enabled;
    };

    hardware.networking = enabled;

    security.agenix = enabled;

    services = {
      docker = enabled;
      postgres = enabled;
      nginx = enabled;

      vaultwarden = enabled;
      firefly = enabled;
      gitea = enabled;
      # soft-serve = enabled;
    };
  };

  # Users configurations

  users.users = {
    semiko = {
      extraGroups = [ "docker" ];
      useDefaultShell = true;
      initialPassword = "password"; # Very secure, indeed
    };
  };

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
