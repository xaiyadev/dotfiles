{ self, lib, ... }:
let
  inherit (lib.types) enum;

  inherit (self.lib.modules) mkOpt;
in
{
  imports = [
    ./amd.nix
  ];

  options.sylveon.hardware.gpu =
     mkOpt (enum [ "amd" ]) null "What gpu your system uses";

  config = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}