{
  imports = [
    ../../systems

    ./lib # The library used by our configuration
    ./shell # Shell environment for this configuration

    ./args.nix # Arguments given to this flake
  ];
}
