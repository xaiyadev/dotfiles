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
  networking.hostName = "huckleberry";

  ${namespace} = {
    nix = { enable = true; lix = enabled; };
    desktop.sway = enabled;

    system = {
      boot = enabled;
      zsh = enabled;
      ssh = enabled;

      fonts = enabled;
      locale = enabled;
    };

    hardware = {
      audio = enabled;
      networking = enabled;

      nvidia = enabled;
    };

    security = {
      agenix = enabled;
    };

    services.docker = enabled;
  };

  ## The Docker configuration needs to be here, because every's user extra Group can only be changed in Nix itself...
  users.users.xaiya.extraGroups = [ "docker" ];

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
