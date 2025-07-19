{
  imports = [
    ./loginManager.nix # The DisplayManager/LoginManager that should be used
    ./sway.nix # Sway Window Manager
    ./boot # Boot configuration (loader and general)
  ];
}