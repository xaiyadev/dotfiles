{
  lib,
  self,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    concatStringsSep
    getExe
    ;

  inherit (lib.types) enum nullOr;
  inherit (self.lib.modules) mkOpt;

  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPath = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];

  cfg = config.sylveon.system.loginManager;
  prof = config.sylveon.profiles;
in
{
  options.sylveon.system.loginManager = mkOpt (nullOr (enum [
    "greetd"
    "gdm"
  ])) (if prof.graphical.enable then "greetd" else null) "The login manager used by the system";

  config = {
    services.greetd = mkIf (cfg == "greetd") {
      enable = true;

      settings = {
        default_session = {
          user = "greeter";
          command = concatStringsSep " " [
            (getExe pkgs.greetd.tuigreet)
            "--time"
            "--asterisks"
            "--sessions '${sessionPath}'"
          ];
        };
      };
    };

    services.displayManager.gdm.enable = (cfg == "gdm");
  };
}
