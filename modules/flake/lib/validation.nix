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

  # Search through every home-module configuration and check if this module is anywhere activated
  anyHomeModuleActive =
    config: modulePath:
    let
      modulesList = (forEach config.sylveon.system.users (name:
        getAttrFromPath modulePath config.home-manager.users.${name}
      ));
    in
      any (x: x) modulesList;

in
{ inherit anyHomeModuleActive; }