{ self, lib, ... }:
let
  inherit (lib.types) enum bool;

  inherit (self.lib.modules) mkOpt;
in
{
  imports = [
    ./displayManager
    ./windowManager
  ];

  options.sylveon.system.graphical = {
    displayManager = mkOpt (enum [ "sddm" "gdm" ]) null "What displayManager should be used";

    windowManagers = {
      gnome.enable = mkOpt bool false "Whether or not to enable the gnome window manager";
      sway.enable = mkOpt bool false "Whether or not to enable the sway window manager";
    };
  };
}