{ lib, config, ... }:
let
  sylveonLib = lib.fixedPoints.makeExtensible ( final: {
      modules = import ./modules.nix { inherit lib; };
      users = import ./users.nix { inherit lib; };
      validation = import ./validation.nix { inherit lib config; };

      inherit (final.modules) mkOpt;
      inherit (final.users) hasGroup;
      inherit (final.validation) anyHomeModuleActive;
  });

in
{
  # How do I call lib?
  # self.lib - calling my new cool library
  # lib - call nixos default library
  flake.lib = sylveonLib;
}
