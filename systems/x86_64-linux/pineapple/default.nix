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
  age.rekey.hostPubkey = ./pineapple-pubkey.pub;

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
        wifi.ensureProfiles = enabled;
        #vpn = enabled; TODO: enabled when age configured
      };

      bluetooth = enabled;
    };

    security = {
      yubikey = enabled;
      agenix = enabled;
    };
    services.docker = enabled;
  };

  # User configuration/groups

  ## The Docker configuration needs to be here, because every's user extra Group can only be changed in Nix itself...
  users.users.xaiya.extraGroups = [ "docker" ];
  users.users.workaholic.extraGroups = [ "docker" ];

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
