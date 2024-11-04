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
    cfg = config.${namespace}.common.nix;
in
{
    options.${namespace}.common.nix = {
        enable = mkEnableOption "Default nix settings setup and configured";
        lix.enable = mkEnableOption ''Use the LIX package instead of the NIX package'';

    };

    config = mkIf cfg.enable {
      nix = {
        package = mkIf cfg.lix.enable pkgs.lix; # Enable LIX
        settings = {
          substituters = [ "https://cache.nixos.org/" "https://ezkea.cachix.org" "https://devenv.cachix.org" ];
          trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];

          experimental-features = [ "nix-command" "flakes" ];
          builders-use-substitutes = true;
          auto-optimise-store = true;
          keep-derivations = true;
          keep-outputs = true;
          warn-dirty = false;
          max-jobs = "auto";

          trusted-users = [ "semiko" "workaholic" ];
        };

        # configure nix language server nixPath
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

        # Garbage collection configuration.
        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 3d";
        };
      };

    };
}
