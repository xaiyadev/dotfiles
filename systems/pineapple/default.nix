{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ./fileSystem.nix

    inputs.aagl.nixosModules.default
  ];

  networking.hostName = "pineapple";

  # --- TEMPORARY ---
  nix.settings = inputs.aagl.nixConfig;
  programs.sleepy-launcher.enable = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.xpadneo ];

  programs.steam.enable = true;
  environment.systemPackages = [ 
    pkgs.gamescope 
    pkgs.spotify
    pkgs.lutris
  ];

  virtualisation.docker = {
    enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

  # --- TEMPORARY ---

  sylveon = {
    profiles = {
      graphical.enable = true;
      laptop.enable = true;
    };

    device = {
      cpu = "amd";
      gpu = "amd";
    };

    system = {
      users = [
        "xaiya"
        "blmedia"
      ];
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
