{ inputs, ... }:
{
  systems = import inputs.systems;

  perSystem =
    { system, pkgs, ... }:
    {
      # configure how packages are built
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;

        config.allowUnfree = true;
      };

      formatter = pkgs.nixfmt-tree;
    };
}
