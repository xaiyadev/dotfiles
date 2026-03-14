{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    # ./fileSystem.nix TODO
  ];

  networking.hostName = "apple";

  sylveon = {
    profiles.server.enable = true;

    device.cpu = "intel";

    system = {
      users = [ "semiko" ];
    };

    services = {
      # General services
      postgres.enable = true;

      # school task
      # nextcloud.enable = true;

    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
