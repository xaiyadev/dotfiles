{
  imports = [ ./hardware.nix ];

  config = {
    sylveon = {
      boot = {
        loader = "grub";
        defaultConfiguration = true;
      };
    };

    system.stateVersion = "25.05";
  };
}