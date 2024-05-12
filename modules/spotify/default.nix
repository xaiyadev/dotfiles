{ pkgs, lib, spicetify-nix, fetchgit, ... }:
let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
  coverAmbience = fetchgit {
        url = "https://github.com/Theblockbuster1/spicetify-extensions/";
        rev = "main";
        hash = "eb0075e6e3e380b12ee29f580028b96b0b7cdf59";
  };
in
{

  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];

  imports = [ spicetify-nix.homeManagerModule ];

  programs.spicetify =
    {
      enable = true;
      spotifyPackage = pkgs.spotify;


      theme = spicePkgs.themes.Default;
      customColorScheme = {
            text = "F2F2F2";
            subtext = "BABABA";
            sidebar-text = "F2F2F2";

            main = "000000";
            sidebar = "000000";
            player = "000000";
            card = "000000";

            shadow = "464646";
            selected-row = "F2F2F2";

            button = "575757";
            button-active = "9E9E9E";
            button-disabled = "646464";

            tab-active = "000000";

            notification = "B2B2B2";
            notification-error = "700000";

            misc = "000000";
      };

      enabledCustomApps = with spicePkgs.apps; [
        lyrics-plus
      ];

      enabledExtensions = with spicePkgs.extensions; [
        songStats
        lastfm
        skipStats
        /* genre */


        playlistIcons
        showQueueDuration

        powerBar

        hidePodcasts

      ];
    };

}