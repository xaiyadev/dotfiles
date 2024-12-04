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
  networking.hostName = "pineapple";

  ${namespace} = {
    nix = { enable = true; lix = enabled; };
    desktop.sway = enabled;

    system = {
      boot = enabled;

      fonts = enabled;
      locale = enabled;
    };

    hardware = {
      audio = enabled;

      networking = {
        enable = true;
        wifi = {  ensureProfiles = enabled; }; # TODO: VPN enabled
      };

      bluetooth = enabled;
    };

    security.yubikey = enabled;
    services.docker = enabled;
  };

  # User configuration/groups

  ## The Docker configuration needs to be here, because every's user extra Group can only be changed in Nix itself...
  users.users.xaiya.extraGroups = [ "docker" ];
  users.users.workaholic.extraGroups = [ "docker" ];

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
