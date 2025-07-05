{ lib, config, pkgs, ... }:
let
  inherit (lib.modules) mkIf;

  displayManager = config.sylveon.system.graphical.displayManager;
in
{

  config = {
     services.displayManager.sddm = {
         enable = displayManager == "sddm";
         package = pkgs.kdePackages.sddm; # this package adds functionality for themes

         wayland.enable = true;
     };
  };

}