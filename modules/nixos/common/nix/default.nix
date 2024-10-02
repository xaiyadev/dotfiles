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
        use-lix = mkOption {
          type = types.bool;
          default = false;
          description = "Use Lix instead of Nix";
        };

    };

    config = mkIf cfg.enable {
      # Install nix langauges server
      environment.systemPackages = with pkgs; [ nil ];
      nix = {
        package = mkIf cfg.use-lix pkgs.lix; # Enable LIX
        settings = {
          substituters = [ "https://cache.nixos.org/" "https://ezkea.cachix.org" ];
          trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];

          experimental-features = [ "nix-command" "flakes" ];
          builders-use-substitutes = true;
          auto-optimise-store = true;
          keep-derivations = true;
          keep-outputs = true;
          warn-dirty = false;
          max-jobs = "auto";
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
