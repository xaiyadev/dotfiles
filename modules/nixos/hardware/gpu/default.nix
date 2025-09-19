{ self, lib, ... }:
let
  inherit (lib.types) enum nullOr;

  inherit (self.lib.modules) mkOpt;
in
{
  imports = [
    ./amd.nix
  ];

  options.sylveon.device.gpu = mkOpt (nullOr (enum [ "amd" ])) null "What gpu your system uses";

  config = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
