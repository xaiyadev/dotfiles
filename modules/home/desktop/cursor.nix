{
  self,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;

  prof = osConfig.sylveon.profiles;
in
{

  config = mkIf prof.graphical.enable {
    home.pointerCursor = {
      enable = true;

      name = "BreezeX-RosePineDawn-Linux";
      package = pkgs.rose-pine-cursor;
      size = 32;

      sway.enable = true;
      gtk.enable = true;
    };
  };
}
