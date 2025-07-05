{ lib, config, pkgs, ... }:
let
  inherit (lib.modules) mkIf;

  cfg = config.sylveon.system.graphical.windowManagers.sway;
in
{

  config = mkIf (cfg.enable) {
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;

      extraSessionCommands = ''
        # export QT_QPA_PLATFORM=wayland ~ Enpass can not be opened with this set TODO !

        export SDL_VIDEODRIVER=wayland
        export MOZ_ENABLE_WAYLAND=1

        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
      '';

    };
  };

}
