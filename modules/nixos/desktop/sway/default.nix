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

  # Deprecated after huckleberry removal
  sessionPackage = pkgs.writeTextFile {
      name = "sway.desktop";
      destination = "/share/wayland-sessions/sway.desktop";

      text = ''
        [Desktop Entry]
        Name=Sway
        Comment=Startup sway
        Exec=${pkgs.sway}/bin/sway --unsupported-gpu
        Type=Application
      '';

      checkPhase = ''${pkgs.buildPackages.desktop-file-utils}/bin/desktop-file-validate "$target"'';
      derivationArgs = { passthru.providedSessions = [ "sway" ]; };
  };
in {

  options.${namespace}.desktop.sway = with types; {
    enable = mkBoolOpt false "Whether or not to enable the GDM display manager";
    session.sessionPackage = mkOpt (listOf package) [ ] "The session package that should be injected into GDM";
  };

  # This part only configures the GDM desktop Manager and the session
  # For configuration and addons please visit modules/home/desktop
  config = mkIf cfg.enable {
    services.xserver.displayManager.gdm = {
        enable = true;
        wayland = true;
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
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
      '';
    };

    # Create own Session, because
    services.displayManager.sessionPackages = [ sessionPackage ] ++ cfg.session.sessionPackage;
    services.displayManager.defaultSession = "sway";

  };
}
