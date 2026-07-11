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
      postgres.enable = true;
      nginx.enable = true;
      docker.enable = true;

      # ---

      kitchenowl.enable = true;
      vaultwarden.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
