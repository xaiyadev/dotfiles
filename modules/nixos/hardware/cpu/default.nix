{ self, lib, ... }:
let
  inherit (lib.types) enum;

  inherit (self.lib.modules) mkOpt;
in
{
  imports = [
    ./amd.nix
    ./intel.nix
  ];

  options.sylveon.device.cpu = mkOpt (enum [ "amd" "intel" ]) null "What cpu your system uses";

}
