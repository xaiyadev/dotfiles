{
  imports = [ ./hardware.nix ];
  sylveon = {
    boot = {
      defaultConfiguration = true;
      loader = "grub";
    };
  };
}