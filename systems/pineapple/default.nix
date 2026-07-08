{
  # TODO: needs changes because.. ueghh,, Framework burned maybe
  imports = [
    ./fileSystem.nix
  ];

  sylveon = {

    profiles = {
      graphical.enable = true;
    };

    users = [
      "xaiya"
      "blmedia"
    ];

    hardware = {
      cpu = "amd";
      gpu = "nvidia";
    };

    services.docker.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
