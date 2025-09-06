{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./fileSystem.nix
  ];

  networking.hostName = "apricot";

  sylveon = {
    profiles = {
      server.enable = true;
    };

    device.cpu = "intel";

    system = {
      users = [ "semiko" ];
    };

    services = {
      postgres.enable = true;
      nginx.enable = true;
      docker.enable = true;
      
      vaultwarden.enable = true;
      gitlab.enable = true;
      glance.enable = true;
      firefly.enable = true;
      kitchenowl.enable = true;

      plex.enable = true;

      minecraft.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
