{
  imports = [
    ./fileSystem.nix
  ];

  networking.hostName = "apricot";

  sylveon = {
    profiles.server.enable = true;

    users = [ "xaiya" ];
    hardware.cpu = "intel";

    services = {
      docker.enable = true;
      nginx.enable = true;

      # -- services
      immich.enable = true;
      kitchenowl.enable = true;
      webdav.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
