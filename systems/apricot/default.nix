{
  imports = [
    ./fileSystem.nix
  ];

  sylveon = {

    users = [ "semiko" ];
    hardware.cpu = "intel";

    services = {
      docker.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
