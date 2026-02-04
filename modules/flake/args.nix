{ inputs, ... }:
{
  # This flake, currently just uses pure nixOS systems
  # set the system flake output here
  systems = [ "x86_64-linux" ];

  perSystem =
    { system, ... }:
    {
      # control how packages are built within the flake
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;

        config.allowUnfree = true;
        overlays = [ ];
      };
    };
}
