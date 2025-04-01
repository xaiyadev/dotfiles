{ lib, ... }:
let
  sylveonLib = lib.makeExtensible ( final: {
    namespace = "sylveon";
  });

in
{
  flake.lib = sylveonLib;

}
