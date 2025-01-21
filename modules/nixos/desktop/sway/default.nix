{
  lib,
  pkgs,
  inputs,

  namespace,
  system,
  target,
  format,
  virtual,
  systems,

  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.sway;
in {

  options.${namespace}.desktop.sway = with types; {
    enable = mkBoolOpt false "Whether or not to enable the GDM display manager";
    session.sessionPackage = mkOpt (listOf package) [ ] "The session package that should be injected into GDM";
  };

  # For configuration and addons please visit modules/home/desktop
  config = mkIf cfg.enable {
    services.displayManager.sddm = {
        enable = true;
        wayland = enabled;
    };
    programs.sway = {
      enable = true;

      wrapperFeatures.gtk = true;

      extraPackages = with pkgs; [
        vulkan-tools

        wl-clipboard
        wf-recorder

        grim
        slurp
      ];

      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        # export QT_QPA_PLATFORM=wayland // Enpass can not be opened with this set
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
      '';
    };
  };
}
