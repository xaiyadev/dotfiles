{
  imports = [
    ./networking # all things network related (vpn, wi-fi, etc.)
    ./cpu.nix
    ./gpu.nix
    ./power.nix # power-management (for mostly system that have batteries (laptops))
    ./audio.nix # Audio settings and configuration (pipewire; alsa; etc.)
    ./bluetooth.nix
    ./yubikey.nix
  ];
}