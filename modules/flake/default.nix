{

  imports = [
    ./lib # add my own library
    ./args.nix # Pass arguments used by the flake

    ../../systems
  ];

  config = {
    # Activate debug tools for flakes
    debug = true;
  };

}
