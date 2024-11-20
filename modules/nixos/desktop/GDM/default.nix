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
  cfg = config.${namespace}.desktop.gdm;

  sessionPackage = pkgs.writeTextFile { # Currently only sway exists for this system, so I will continue with that overall through the entire System
      name = "sway.desktop";
      destination = "/share/wayland-sessions/sway.desktop";

      # Unsupported GPU is needed for nvidia cards, will be deprecated when huckleberry is removed
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

  # I use GDM because right now there is a bug in SDDM if you login to fast - after fix maybe switch back to SDDM
  options.${namespace}.desktop.gdm = with types; {
    enable = mkBoolOpt false "Whether or not to enable the GDM display manager";
    session.sessionPackage = mkOpt (listOf package) [ sessionPackage ] "The session package that should be injected into SDDM";
    session.defaultSession = mkOpt str "sway" "What should be the default option for GDM"; # Currently sway, because its the only thing I use right now
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.gdm = {
        enable = true;
        wayland = true;
      };

    services.displayManager.sessionPackages = cfg.session.sessionPackage;
    services.displayManager.defaultSession = cfg.session.defaultSession;
  };
}
