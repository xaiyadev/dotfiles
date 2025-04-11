{ lib, ... }:
let
  sylveonLib = lib.fixedPoints.makeExtensible ( final: {
      modules = import ./modules.nix { inherit lib; };

      inherit (final.modules) mkOpt;
  });

in
{
# How do I call lib?
# self.lib - calling my new cool library
# lib - call nixos default library
flake.lib = sylveonLib;
}
