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
    cfg = config.${namespace}.programs.spotify;
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

in
{
    imports = [
       inputs.spicetify-nix.homeManagerModules.default
    ];

    options.${namespace}.programs.spotify = {
        enable = mkEnableOption "install spotify and activate spicetify settings";
    };

    config = mkIf cfg.enable {
       programs.spicetify = {
            enable = true;

            theme = spicePkgs.themes.catppuccin;
            colorScheme = "Mocha";

            enabledExtensions = with spicePkgs.extensions; [
               bookmark
               fullAppDisplay
               showQueueDuration
               betterGenres
               copyLyrics
               shuffle # shuffle+ (special characters are sanitized out of extension names)
            ];

            enabledCustomApps = with spicePkgs.apps; [
                newReleases
                historyInSidebar
            ];
       };
    };
}