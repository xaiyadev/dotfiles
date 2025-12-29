{
  osConfig,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  prof = osConfig.sylveon.profiles;
in
{

  /*
    TODO 
    manual configurutions/needs to automate
    - TIDALuna
    - Jetbrains IDE
    - Sway (flmaingo stuff)
    - Kitty (write own config?)
    - vicaine

    - firefox browser websites
    - rose-pine alternative (?)
  */

  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  /* Configurating the basic theme */
  config = mkIf prof.graphical.enable {
    catppuccin = {
      enable = true;
      cache.enable = true;

      accent = "flamingo";
      flavor = "mocha";
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
