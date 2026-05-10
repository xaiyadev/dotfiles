{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;

  prof = config.sylveon.profiles;
in
{
  gtk = mkIf prof.graphical.enable {
    enable = true;

    theme = {
      name = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}-standard";
      package = pkgs.catppuccin-gtk.override {
        size = "standard";
        accents = [ config.catppuccin.accent ];
        variant = config.catppuccin.flavor;
      };
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;

      # stop annoying sounds
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
      gtk-error-bell = 0;
    };

    gtk4 = {
      inherit (config.gtk) theme;

      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };
}