{ osConfig, lib, pkgs, ... }:
let
  inherit (lib.modules) mkIf;

  windowManager = osConfig.sylveon.system.graphical.windowManagers;
in
{

  config = mkIf (builtins.elem "gnome" windowManager) {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
         disable-user-extensions = false;
         enabled-extensions = [
          pkgs.gnomeExtensions.gsconnect.extensionUuid
         ];
        };
      };
    };
  };
}