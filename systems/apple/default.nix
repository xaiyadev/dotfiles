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

  networking.hostName = "apple";

  sylveon = {
    profiles.server.enable = true;

    device.cpu = "intel";

    system = {
      users = [ "semiko" ];
    };

    services = {
      # school task
      nextcloud.enable = true;

    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
