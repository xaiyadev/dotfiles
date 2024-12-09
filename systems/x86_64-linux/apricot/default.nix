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
  age.rekey.hostPubkey = ./apricot-pubkey.pub;


  ${namespace} = {
    nix = { enable = true; lix = enabled; };
    # no desktop environment needed, its a server ¯\_(ツ)_/¯

    system = {
      boot = enabled;
      ssh = enabled;

      fonts = enabled;
      locale = enabled;
    };

    hardware.networking = enabled;

    security.agenix = enabled;

    services = {
      docker = enabled;
      nginx = enabled;

      homepage = enabled;
      vaultwarden = enabled;
      firefly = enabled;
    };
  };

  # User configuration

  ## The Docker configuration needs to be here, because every's user extra Group can only be changed in Nix itself...
  users.users.semiko.extraGroups = [ "docker" ];

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
