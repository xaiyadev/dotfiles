{ inputs, ... }:
{
  imports = [
    inputs.agenix-rekey.flakeModule

    ../../systems

    ./lib # The library used by our configuration
    ./checks # tests and checks from our configuration
    ./shell # Shell environment for this configuration

    ./args.nix # Arguments given to this flake
  ];
}
