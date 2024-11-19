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
    system = {
      boot = enabled;

      fonts = enabled;
      locale = enabled;
    };

    hardware = {
      audio = enabled;

      networking = {
        enable = true;

        wifi = {
          ensureProfiles = enabled;
          #vpn = enabled;
        };
      };
    };

  };

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
