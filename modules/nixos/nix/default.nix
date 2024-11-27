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
    cfg = config.${namespace}.nix;
in
{
    options.${namespace}.nix = with types; {
        enable = mkBoolOpt false "Default nix settings setup and configured";
        lix.enable = mkBoolOpt false ''Use the LIX package instead of the NIX package'';
    };

    config = mkIf cfg.enable {

      # Enable Nix Caches
      ${namespace}.nix.cache = {
        public = enabled;
      };

      nix = {
        package = mkIf cfg.lix.enable pkgs.lix; # Enable LIX
        settings = {
          experimental-features = [ "nix-command" "flakes" ];
          builders-use-substitutes = true;
          auto-optimise-store = true;

          # Keeping builds (will be removed later from the garbage collector)
          keep-derivations = true;
          keep-outputs = true;

          # Warning and Error logs
          warn-dirty = false;
          max-jobs = "auto";

          # Users allowed to use the nix command
          trusted-users = [ "xaiya" ];
        };

        # Garbage collection configuration.
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
      };

    };
}