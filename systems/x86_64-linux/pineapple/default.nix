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
      zsh = enabled;
      ssh = enabled;

      fonts = enabled;
      locale = enabled;
    };

    hardware = {
      audio = enabled;

      networking = {
        enable = true;
        wifi = enabled;
      };

      bluetooth = enabled;
    };

    security = {
      yubikey = enabled;
      agenix = enabled;
    };

    services.docker = enabled;
  };

  # Users configuration
  users.users.xaiya = mkUserConfiguration "password" [ ];
  users.users.workaholic  = mkUserConfiguration "password" [ ];

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
