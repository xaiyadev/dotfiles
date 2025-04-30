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

  system.stateVersion = "25.05";
}