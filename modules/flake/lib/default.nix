{ lib, inputs, ... }:
let
  sylveonLib = lib.fixedPoints.makeExtensible ( final: {
    modules = import ./modules.nix { inherit lib; };

    inherit (final.modules) mkOpt;
  });

  finalLib = lib.extend (final: prev: sylveonLib);
in
{ flake.lib = finalLib; }