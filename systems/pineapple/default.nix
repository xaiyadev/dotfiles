{ pkgs, inputs, config, ... }: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ./fileSystem.nix

    inputs.aagl.nixosModules.default
  ];

  /* --- TEMPORARY --- */
    nix.settings = inputs.aagl.nixConfig;
    programs.sleepy-launcher.enable = true;
    boot.extraModulePackages = [ config.boot.kernelPackages.xpadneo ];

    programs.steam.enable = true;
    environment.systemPackages = [ pkgs.gamescope ];

  /* --- TEMPORARY --- */

  networking.hostName = "pineapple";

  sylveon = {
    users = [ "xaiya" "blmedia" ];

    device.name = "pineapple";
    profiles = [ "laptop" ];

    virtualization = {
      libvirt.enable = true;
    };

    hardware = {
      cpu = "amd";
      gpu = "amd";

      bluetooth.enable = true;

      inputs.touchpad.accelSpeed = -0.2;
    };

    theme = {
      name = "rose-pine";

      cursor = {
        name = "BreezeX-RosePineDawn-Linux";
        package = pkgs.rose-pine-cursor;
      };
    };

    system = {
      boot.loader = "grub";
      graphical = {
        displayManager = "gdm";
        windowManagers = [ "gnome" "sway" ];
      };
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
