{
  imports = [
    ./networking # all things network related (vpn, wi-fi, etc.)
    ./cpu.nix
    ./gpu
    ./power.nix # power-management (for mostly system that have batteries (laptops))
    ./bluetooth.nix
    ./yubikey.nix

    ./firmware.nix # updating firmware
    ./fw-fanctrl.nix # configuration for framework-specific tools (e.g fw-fanctrl)

    ./media # media configuration (e.g video and audio)
  ];
}
