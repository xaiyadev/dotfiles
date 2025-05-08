{ lib, config, self, inputs', inputs, ... }:
let
  inherit (lib.attrsets) genAttrs;
in
{

  config = {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users = genAttrs config.sylveon.users (name: ./${name});

      extraSpecialArgs = {
        inherit
          self
          inputs
          inputs'
          ;
      };

      sharedModules = [ "${self}/modules/home/default.nix" ];
    };
  };

}