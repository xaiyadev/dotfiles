{ self, lib, ... }:
let
  inherit (lib.types) enum;

  inherit (self.lib.modules) mkOpt;
in
{
  imports = [
    ./amd.nix
  ];

  # TODO: add intel for apricot
  # TODO: move to a global option? (in base)
  options.sylveon.hardware.cpu =
     mkOpt (enum [ "amd" ]) null "What cpu your system uses";

}