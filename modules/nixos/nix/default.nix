{
  imports = [
    ./caches.nix # caches that our nix environment should use
    ./nix.nix # configuration for the nix command/environment
    ./nixpkgs.nix # configuration for package management
  ];
}
