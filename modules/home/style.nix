{
  osConfig,
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.catppuccin;
in
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  # Use the global catppuccin configuration
  # TODO: applications that need to be manaul integrated/need nix integration
  config = mkIf osConfig.catppuccin.enable {
    catppuccin = {
      enable = true;

      inherit (osConfig.catppuccin)
        accent
        flavor
        ;
    };

    gtk = {
      enable = true;

      theme = {
        name = "catppuccin-${cfg.flavor}-${cfg.accent}-standard";
        package = pkgs.catppuccin-gtk.override {
          size = "standard";
          accents = [ cfg.accent ];
          variant = cfg.flavor;
        };
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };

      gtk4 = {
        inherit (config.gtk) theme;
        extraConfig = {
          # make things look nice
          gtk-application-prefer-dark-theme = true;
        };
      };
    };

    home.pointerCursor = {
      enable = true;

      name = "catppuccin-mocha-flamingo-cursors";
      package = pkgs.catppuccin-cursors.mochaFlamingo;
      size = 24;

      sway.enable = true;
      gtk.enable = true;
    };
  };
}
