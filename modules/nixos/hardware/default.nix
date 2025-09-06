{
  imports = [
    ./networking
    ./cpu
    ./gpu

    ./audio.nix
    ./power.nix
    ./bluetooth.nix
    ./yubikey.nix
    ./controller.nix
  ];

  config = {
    # Enables non-free firmware
    hardware.enableRedistributableFirmware = true;
  };

}
