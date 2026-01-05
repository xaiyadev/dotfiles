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

  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  /* Configurating the basic theme */
  /*
   * TODO: global catpuccin
  */
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
