{ self, lib, ... }:
let
  inherit (lib.types) nullOr listOf enum;

  inherit (self.lib.modules) mkOpt;
in
{
  imports = [
    ./displayManager
    ./windowManager
  ];

  options.sylveon.system.graphical = {
    displayManager = mkOpt (nullOr (enum [ "sddm" "gdm" ])) null "What displayManager should be used";
    windowManagers = mkOpt (nullOr (listOf(enum [ "gnome" "sway" ]))) null "List of Window manager that should be installed";
  };
}