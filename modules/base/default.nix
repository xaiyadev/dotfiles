/* Basic variables and configurations */

{ ... }:
let
  inherit (lib.types) str;

  inherit (self.lib.modules) mkOpt;
in
{

  imports = [
    ./profiles.nix
    ./theme.nix
  ];

  config = {
    options.sylveon = {
      name = mkOpt str null "The devices name";
    };
  };
}