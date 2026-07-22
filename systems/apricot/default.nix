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

      # -- services
      immich.enable = true;
      nginx.enable = true;

      # -- TODO
      # -- add keepass support (new way for storring passwords)
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
