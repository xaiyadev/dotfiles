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
      networking = enabled;

      fonts = enabled;
      locale = enabled;
    };
  };

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
