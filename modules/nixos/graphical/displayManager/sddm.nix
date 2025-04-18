{ lib, config, pkgs, ... }:
let
  inherit (lib.modules) mkIf;

  displayManager = config.sylveon.system.graphical.displayManager;
in
{

  # TODO: Add your own theme
  config = mkIf (displayManager == "sddm") {
     services.displayManager.sddm = {
         enable = true;
         package = pkgs.kdePackages.sddm; # this package adds functionality for themes

         wayland.enable = true;
     };
  };

}