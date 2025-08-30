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

  # --- TEMPORARY ---

  virtualisation.docker.enable = true;

  # --- TEMPORARY ---

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
      
      vaultwarden.enable = true;
      gitlab.enable = true;
      glance.enable = true;
      firefly.enable = true;

      minecraft.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
