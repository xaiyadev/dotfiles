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
let
  cfg = config.${namespace}.system.networking;
in {

  options.${namespace}.system.networking = {
    enable = mkBoolOpt false "Wheter or not to install all network settings";
  };

  config = mkIf cfg.enable {
    networking = {
      resolvconf = {
        enable = true;
        # Fix IPv6 DNS request load times
        dnsSingleRequest = true;

        # Use the right DNS Server instead of the one of the local server (why fritzbox...)
        extraConfig = ''
          nameserver 1.1.1.1
          nameserver 8.8.8.8
        '';
      };

      # TODO: add profiles for networks + VPN
      networkmanager = enabled;
    };
  };
}
