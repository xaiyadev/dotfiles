{ lib, ... }:
let
  sylveonLib = lib.fixedPoints.makeExtensible ( final: {
      modules = import ./modules.nix { inherit lib; };

      inherit (final.modules) mkOpt;
  });

in
{ flake.lib = sylveonLib; }
