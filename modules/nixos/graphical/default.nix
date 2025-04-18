{ self, lib, ... }:
let
  inherit (lib.types) nullOr enum;

  inherit (self.lib.modules) mkOpt;
in
{
  imports = [
    ./displayManager/sddm.nix
  ];

  options.sylveon.system.graphical = {
    displayManager = mkOpt (nullOr (enum [ "sddm" "gdm" ])) null "What displayManager should be used";
  };
}