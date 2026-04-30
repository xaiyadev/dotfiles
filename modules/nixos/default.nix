{
  imports = [
    ./nix # nix environment configuration (e.g nixpkgs)
    ./environment # Configurations of the systems environment (timezone; fonts; etc.)
    ./system # System configuration itself (window-manager; login-manager; etc.)
    ./hardware # hardware specific configuration (cpu; gpu; touchpad; etc.)
    ./boot # Configuration for booting up the system (e.g bootloader)
    ./security # Security of the system (yubikey; sudo)
    ./networking # network configuration (internet; tailscale; vpn; etc.)
    ./services # services mostly used by the server (websites; databases)
    ./programs # default programs that should or need to be run system-wide

    ./style.nix # Configure the users style configuration
    ./users.nix # Configure the users given in this environment
  ];
}
