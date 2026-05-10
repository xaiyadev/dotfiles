{ pkgs, config, ... }:
{
  imports = [
    ./catppuccin.nix
    ./gtk.nix
    ./qt.nix
  ];

  config = {
    # global configuration for cursors
    home.pointerCursor = {
      inherit (config.sylveon.profiles.graphical) enable;

      name = "catppuccin-mocha-flamingo-cursors";
      package = pkgs.catppuccin-cursors.mochaFlamingo;
      size = 24;

      sway.enable = true;
      gtk.enable = true;
    };
  };
}
