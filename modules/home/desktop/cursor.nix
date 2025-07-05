{ self, pkgs, ... }:
{

  config = {
    home.pointerCursor = {
      enable = osConfig.sylveon.profiles.graphical;

      name = "BreezeX-RosePineDawn-Linux";
      package = pkgs.rose-pine-cursor;
      size = 32;

      sway.enable = true;
      gtk.enable = true;
  };
  };
}