{ lib, config, ... }:
let
  displayManager = config.sylveon.system.graphical.displayManager;
in
{ services.displayManager.gdm.enable = displayManager == "gdm"; }
