{ lib, config, ... }:
let
  inherit (lib.modules) mkIf;

  displayManager = config.sylveon.system.graphical.displayManager;
in
{ services.displayManager.gdm.enable = mkIf (displayManager == "gdm") true; }
