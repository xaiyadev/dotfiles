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
    ];

    hardware = {
      cpu = "amd";
      gpu = "amd";
    };

    services.docker.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
