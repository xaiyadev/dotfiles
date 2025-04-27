{ self, ... }:
let

  mkModule =
    {
      name ? "sylveon",
      class,
      modules,
    }:
    {
      _class = class;
      _file = "${self.outPath}/flake.nix#${class}Modules.${name}";

      imports = modules;
    };

in
{
  flake.nixosModules = {
    sylveon = mkModule {
      class = "nixos";
      modules = [ "${self}/modules/nixos/default.nix" ];
    };
  };

}