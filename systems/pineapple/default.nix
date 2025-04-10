{
  imports = [ ./hardware.nix ];

  sylveon = {
    boot = {
      loadRecommendedConfiguration = true;
      loader = "grub";
    };
  };

}