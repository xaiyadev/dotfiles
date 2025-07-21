{ inputs, ... }:
{
  imports = [
    inputs.agenix-rekey.flakeModule

    ../../systems

    ./modules.nix # Inject modules into flake
    ./lib # add my own library
    ./args.nix # Pass arguments used by the flake
    ./shell.nix # A development environment for this system

  ];
}
