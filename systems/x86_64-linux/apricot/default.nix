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
  networking.hostName = "apricot";

  ${namespace} = {
    nix = { enable = true; lix = enabled; };
    # no desktop environment needed, its a server ¯\_(ツ)_/¯

    system = {
      boot = enabled;

      fonts = enabled;
      locale = enabled;
    };

    hardware = {
      networking.enable = true;

    };

    security.gpg = enabled;
  };

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
