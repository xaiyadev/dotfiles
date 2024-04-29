{ pkgs, lib, spicetify-nix, ... }:
let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
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

      enabledExtensions = with spicePkgs.extensions; [
        songStats
        copyToClipboard
        goToSong
        groupSession
      ];
    };

}