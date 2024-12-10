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
    cfg = config.${namespace}.services.docker;
in
{
    options.${namespace}.services.docker = with types; {
        enable = mkBoolOpt false "Enable the docker service and configure the docker user";

        users = mkOpt (listOf str) [ ] "What users should have access to docker";
    };

    config = mkIf cfg.enable {
      virtualisation.oci-containers.backend = "docker";
      virtualisation.docker = {
        enable  = true;

        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    };
}
