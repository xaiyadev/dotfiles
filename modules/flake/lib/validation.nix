{ lib, ... }:
let
  inherit (lib.lists) any;

  isGraphical =
    # Ask for a config, because of home-manager and the two ways of calling the config
    config:
    let
      windowManagers = config.sylveon.system.graphical.windowManagers;
      displayManager = config.sylveon.system.graphical.displayManager;
    in
     any (x: x != null) [ windowManagers displayManager ];
in
{ inherit isGraphical; }