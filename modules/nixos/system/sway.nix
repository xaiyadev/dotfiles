{ lib, config, pkgs, self, ... }:
let
  inherit (lib)
    mkIf
    concatStringsSep
    ;

  inherit (lib.types) bool;
  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.system.graphical.sway;
  prof = config.sylveon.profiles;
in
{


  options.sylveon.system.graphical.sway.enable = mkOpt
    bool
    prof.graphical.enable # Sway is currently my only windowManager, because of that if I want a graphical interface I automatically want this display manager
    "Whether or not to enable the sway window manager";

  config = mkIf (cfg.enable) {
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;

      extraSessionCommands = concatStringsSep " " [
        "# export QT_QPA_PLATFORM=wayland ~ Enpass can not be opened with this set TODO !"

        "export SDL_VIDEODRIVER=wayland"
        "export MOZ_ENABLE_WAYLAND=1"

        "export XDG_SESSION_TYPE=wayland"
        "export XDG_SESSION_DESKTOP=sway"
        "export XDG_CURRENT_DESKTOP=sway"
      ];
    };
  };

}
