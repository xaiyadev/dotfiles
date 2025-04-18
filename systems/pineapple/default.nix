{
  imports = [ ./hardware.nix ];

  sylveon = {
    profiles = [ "laptop" ];

    system = {
      boot.loader = "grub";
      graphical = {
        displayManager = "sddm";
        windowManagers = [ "gnome" ];
      };
    };
  };

}