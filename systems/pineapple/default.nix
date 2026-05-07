{
  imports = [
    ./fileSystem.nix
  ];

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
      yubikey.enable = true;

      cpu = "amd";
      gpu = "amd";
    };

    services.docker.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
