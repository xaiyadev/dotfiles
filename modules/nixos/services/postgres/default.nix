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
    cfg = config.${namespace}.services.postgres;
in
{
    options.${namespace}.services.postgres = with types; {
        enable = mkBoolOpt false "Enable postgres database for managing the data for my services";
    };

    config = mkIf cfg.enable {
      services.postgresql = {
        enable = true;

        # Allow access to databases for users with the same username
        authentication = pkgs.lib.mkOverride 10 ''
          #type database DBuser origin-address
          local sameuser  all     peer
          host  sameuser  all     ::1/128 reject
        '';

        # MkForce because something other wants to use 'localhost'
        settings.listen_addresses = mkForce "*";

      };
    };
}
