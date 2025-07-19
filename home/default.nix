{ lib, config, self, inputs', inputs, ... }:
let
  inherit (lib.attrsets) genAttrs;
in
{

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = {
    home-manager = {
      verbose = true;
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";

      users = genAttrs config.sylveon.system.users (name: {
        imports = [ ./${name} ];
      });

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