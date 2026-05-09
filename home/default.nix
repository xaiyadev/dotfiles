{
  self,
  lib,
  config,
  inputs,
  inputs',
  ...
}:
let
  inherit (lib) genAttrs;
in
{

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = {
    home-manager = {
      verbose = true;
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";

      users = genAttrs config.sylveon.users (name: {
        imports = [ ./${name} ];
      });

      extraSpecialArgs = { inherit self inputs inputs'; };

      sharedModules = [ "${self}/modules/home/default.nix" ];
    };
  };

}
