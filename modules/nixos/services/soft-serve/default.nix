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
with lib.${namespace};
let
    cfg = config.${namespace}.services.soft-serve;
in
{
    options.${namespace}.services.soft-serve = with types; {
        enable = mkBoolOpt false "enable a minimalistic git server that is managed in the CLI";
    };
    /*
    * This module does not work right now, switching to gitlab for now
    */
    config = mkIf cfg.enable {
      environment.systemPackages = [ pkgs.soft-serve ]; # Add the soft terminal utility

      networking.firewall.allowedTCPPorts = [ 21 23233 ];
      services.soft-serve = {
        enable = true;

        settings = {
          name = "Xaiya's synchronisation repos";
          log_format = "txt";
          ssh = {
            listen_addr = "21"; # 22 is already managed by OpenSSH
            public_url = "ssh://localhost:21";
            max_timeout = 30;
            idle_timeout = 120;
          };
          stats.listen_addr = "23233";
        };
      };
    };
}
