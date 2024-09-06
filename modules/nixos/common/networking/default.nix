{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  specialArgs,
  ...
}:
with lib;
let
    cfg = config.${namespace}.common.networking;
in
{
    options.${namespace}.common.networking = {
        enable = mkEnableOption "Setup Locale settings; time/keyboard etc.";

    };

    config = mkIf cfg.enable {
        networking = {
            hostName = specialArgs.host-name;

            resolvconf = {
                enable = true;
                dnsSingleRequest = true;
                # TODO: add WLAN settings
            };

            firewall.enable = true;
            networkmanager.enable = true;


            nameservers = [ "1.1.1.1" "8.8.8.8" ];


        };
  };
}