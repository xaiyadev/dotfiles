{ pkgs, ... }: {
  imports = [ ./hardware.nix ];

  networking.hostName = "pineapple"; # TODO !

  sylveon = {
    users = [ "xaiya" "blmedia" ];
    profiles = [ "laptop" ];

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
        displayManager = "sddm";
        windowManagers = [ "gnome" "sway" ];
      };
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}