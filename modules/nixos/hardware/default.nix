{
  imports = [
    ./networking
    ./cpu
    ./gpu

    ./audio.nix
    ./power.nix
    ./bluetooth.nix
    ./yubikey.nix
  ];

  config = {
    # Enables non-free firmware
    hardware.enableRedistributableFirmware = true;
  };

}
