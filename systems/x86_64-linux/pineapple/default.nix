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
    desktop = {
      sway = enabled;
      gnome = enabled;
    };

    system = {
      boot = {
        enable = true;
        windows = enabled;
      };
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
      graphics = enabled; # Settings for Gaming and other Graphical Stuff
    };

    security = {
      yubikey = enabled;
      agenix = enabled;
    };

    services = {
      docker = enabled;
      waydroid = enabled;
    };
  };

  # Temporary install
  environment.systemPackages = [ pkgs.${namespace}.lampray ];

  # Users configuration
  age.secrets.xaiya-pwd.rekeyFile = "${inputs.self}/secrets/xaiya.pwd.age";
  age.secrets.workaholic-pwd.rekeyFile = "${inputs.self}/secrets/workaholic.pwd.age";

  users.users.xaiya = mkUserConfiguration config.age.secrets.xaiya-pwd.path [ ];
  users.users.workaholic  = mkUserConfiguration config.age.secrets.workaholic-pwd.path [ ];

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
