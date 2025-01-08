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
  cfg = config.${namespace}.hardware.networking;
in {

  options.${namespace}.hardware.networking = with types; {
    enable = mkBoolOpt false "Wheter or not to install all network settings";
    wifi.enable = mkBoolOpt false "Whether or not to ensure if profiles exists";
    vpn.enable = mkBoolOpt false "Whether or not to enable my home based vpn";
  };

  config = mkIf cfg.enable {

    networking = {
      enableIPv6 = true;

      # Configure Nameservers
      nameservers = [ "1.1.1.1" "1.0.0.1" "9.9.9.9" ];

      resolvconf = {
        enable = true;

        # Fix IPv6 DNS request load times
        dnsSingleRequest = true;
      };

      networkmanager = {
        enable = true;

        wifi = mkIf cfg.wifi.enable {
          powersave = true;
          scanRandMacAddress = true;
        };
      };
    };


    services.tailscale.enable = true;
  };
}
