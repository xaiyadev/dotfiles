# This file is highly inspired from https://github.com/isabelroses/dotfiles/blob/0c9bc76d56bfaf12cbcd05d3f62685958ad0c598/modules/flake/lib/default.nix
{ inputs, ... }:
  
let 
  originLib = inputs.nixpkgs.lib;

  extLib = originLib.makeExtensible {
    config = import ./config; # Special Configurations like the namepsace
  };


  # We need to extend our Lib with the origin Lib to get the Full set of functions
  finalLib = extLib.extend (_: _: originLib);
in 
{
    flake.lib = finalLib;
    perSystem._module.args.lib = finalLib;
}
