{ lib }:
let
  inherit (lib.options) mkOption;


  # Simplified one lining mkOption
  # example: ``mkOpt str "" "Example Option"``
  mkOpt =
    type: default: description:
      mkOption { inherit type default description; };
in
{ inherit mkOpt; }