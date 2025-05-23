{ lib, ... }:
let
  inherit (lib)
    any
    getAttr
    forEach
    ;

  inherit (lib.attrsets)
    getAttrFromPath
    attrByPath
    ;

  isGraphical =
    # Ask for a config, because of home-manager and the two ways of calling the config
    config:
    let
      windowManagers = config.sylveon.system.graphical.windowManagers;
      displayManager = config.sylveon.system.graphical.displayManager;
    in
     any (x: x != null) [ windowManagers displayManager ];

  # Search through every home-module configuration and check if this module is anywhere activated
  anyHomeModuleActive =
    config: modulePath:
    let
      modulesList = (forEach config.sylveon.users (name:
        getAttrFromPath modulePath config.home-manager.users.${name}
      ));
    in
      any (x: x) modulesList;

in
{ inherit isGraphical anyHomeModuleActive; }