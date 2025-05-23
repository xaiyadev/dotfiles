{ inputs, ... }:
{
  systems = import inputs.systems;

  perSystem =
    { system, ... }: {
      # configure how packages are built
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;

        config.allowUnfree = true;
      };
    };
}