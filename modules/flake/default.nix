{

  imports = [
    ../../systems
    ../../lib

    ./args.nix # Pass arguments used by the flake
  ];

  config = {
    # Activate debug tools for flakes
    debug = true;
  };

}
