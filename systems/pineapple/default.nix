{
  imports = [ ./hardware.nix ];

  sylveon = {
    users = [ "xaiya" ];
    profiles = [ "laptop" ];

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