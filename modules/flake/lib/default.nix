{ lib, ... }:
let
  sylveonLib = lib.fixedPoints.makeExtensible ( final: {
      modules = import ./modules.nix { inherit lib; };

      inherit (final.sylveon.modules) mkOpt;
  });

  finalLib = lib.extend (final: prev: sylveonLib);
in
{ flake.lib = finalLib; }
