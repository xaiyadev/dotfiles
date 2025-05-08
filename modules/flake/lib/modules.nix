{ lib }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) package bool;


  # Simplified one lining mkOption
  # example: ``mkOpt str "" "Example Option"``
  mkOpt =
    type: default: description:
      mkOption { inherit type default description; };

 # Create options for a module that has an enable option and a package option in it
  mkPackageOpt =
    pkg: description: {
      enable = mkOpt bool false description;
      package = mkOpt package pkg "Package for this module";
    };

in
{ inherit mkOpt mkPackageOpt; }