{
  imports = [
    ./stylix.nix
    ./cursor.nix

    # Window Manager configuration
    ./gnome
    ./sway

    # Extra packages that are used by multiple desktops
    ./packages
  ];
}