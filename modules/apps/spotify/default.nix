{ pkgs, lib, spicetify-nix, config, ... }:
with lib;
let
    cfg = config.services.spotify;
    spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{

    imports = [
       spicetify-nix.homeManagerModules.default
    ];

    options.services.spotify = {
        enable = mkEnableOption "custom spotify service";
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
