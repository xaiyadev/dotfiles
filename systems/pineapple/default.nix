{
  imports = [ ./hardware.nix ];

  sylveon = {
    system = {
      boot.loader = "grub";
    };
  };

}