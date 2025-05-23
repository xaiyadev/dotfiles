{ self, lib, ... }:
let
  inherit (lib.types) enum;

  inherit (self.lib.modules) mkOpt;
in
{
  imports = [
    ./amd.nix
  ];

  options.sylveon.hardware.cpu =
     mkOpt (enum [ "amd" ]) null "What cpu your system uses";

}