{ self, lib, ... }:
let
  inherit (lib.types) enum listOf str;

  inherit (self.lib.modules) mkOpt;
in
{
  options.sylveon = {
    device.name =
      mkOpt str null "Name of the device";

    profiles =
      mkOpt (listOf (enum [ "laptop" ])) [ ] "Configurations that load with specific profiles.";
  };
}
