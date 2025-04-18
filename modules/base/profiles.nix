{ self, lib, ... }:
let
  inherit (lib.modules) listOf;
  inherit (lib.types) enum;

  inherit (self.lib.modules) mkOpt;
in
{
  options.sylveon.profiles =
    mkOpt (listOf (enum [ "laptop" ])) [ ] "Configurations that load with specific profiles.";
}
