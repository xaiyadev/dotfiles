{ self, lib, ... }:
let
  inherit (lib.types) enum listOf;

  inherit (self.lib.modules) mkOpt;
in
{
  options.sylveon.profiles =
    mkOpt (listOf (enum [ "laptop" ])) [ ] "Configurations that load with specific profiles.";
}
