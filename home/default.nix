{ lib, config, self, ... }:
let
  inherit (lib.attrsets) genAttrs;
in
{

  config = {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users = genAttrs config.sylveon.users (name: ./${name});
      sharedModules = [ "${self}/modules/home/default.nix" ];
    };
  };

}