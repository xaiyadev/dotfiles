{

  imports = [
    ../../systems

    ./modules.nix # Inject modules into flake
    ./lib # add my own library
    ./args.nix # Pass arguments used by the flake

  ];

  config = {
    # Activate debug tools for flakes
    debug = true;
  };

}
