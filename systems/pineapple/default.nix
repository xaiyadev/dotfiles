{ pkgs, inputs, ... }: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ./fileSystem.nix
  ];

  networking.hostName = "pineapple";

  sylveon = {
    users = [ "xaiya" "blmedia" ];

    device.name = "pineapple";
    profiles = [ "laptop" ];

    hardware = {
      cpu = "amd";
      gpu = "amd";

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
