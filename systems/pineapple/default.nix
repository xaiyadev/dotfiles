{
  imports = [
    ./fileSystem.nix
  ];

  # These settings are only framework related, should I create an own module? TODO
  hardware.fw-fanctrl = {
    enable = true;
  };

  sylveon = {

    profiles = {
      graphical.enable = true;
      laptop.enable = true;
    };

    users = [
      "xaiya"
      "blmedia"
    ];

    hardware = {
      cpu = "amd";
      gpu = "amd";

      yubikey.enable = true;
    };

    services.docker.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
