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
    profiles.server.enable = true;

    device.cpu = "intel";

    system = {
      users = [ "semiko" ];
    };

    services = {
      # General services
      postgres.enable = true;
      nginx.enable = true;
      docker.enable = true;

      # Docker based services
      kitchenowl.enable = true;

      # System-managed services
      glance.enable = true;

      vaultwarden.enable = true;

      tangled = {
        knot.enable = true;
        spindle.enable = true;
      };

      # https://github.com/teal-fm/piper/issues/42
      # piper.enable = true;

      radicale.enable = true;

      plex.enable = true;
      minecraft.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
