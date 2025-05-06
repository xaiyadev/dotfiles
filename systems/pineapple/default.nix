{ pkgs, ... }: {
  imports = [ ./hardware.nix ];

  sylveon = {
    users = [ "xaiya" ];
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
        windowManagers = [ "gnome" ];
      };
    };
  };


  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}