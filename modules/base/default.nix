# Basic variables and configurations
{ lib, self, ... }:
let
  inherit (lib.types) str;
  inherit (self.lib.modules) mkOpt;
in
{

  imports = [
    ./profiles.nix
    ./theme.nix
  ];
}
