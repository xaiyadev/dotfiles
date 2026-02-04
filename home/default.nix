{
  self,
  inputs,
  ...
}:
{

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = {
    home-manager = {
      verbose = true;
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";

      extraSpecialArgs = { };

      sharedModules = [ "${self}/modules/home/default.nix" ];
    };
  };

}
