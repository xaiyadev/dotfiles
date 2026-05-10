{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.graphical.sway;
  prof = config.sylveon.profiles;
in
{

  options.sylveon.graphical.sway.enable =
    mkEnableOption "Whether or not to enable the sway window manager"
    // {
      default = prof.graphical.enable; # Sway is currently my only windowManager
    };

  config = mkIf cfg.enable {
    # Enable important services to work for some applications
    services.gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };

    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
    };
  };

}
