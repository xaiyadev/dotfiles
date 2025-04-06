{ inputs, ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    { system, ... }:
    {
      # this is what controls how packages in the flake are built

      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };
    };
}