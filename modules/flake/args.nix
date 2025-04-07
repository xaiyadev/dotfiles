{ inputs, ... }:
{
  # An array of what systems are used in this flake
  # TODO: automate?
  systems = [ "x86_64-linux" ];

  perSystem =
    { system, ... }:
    {
      # configure how packages are built
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };
    };
}