{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    concatStringsSep
    getExe
    mkOption
    ;

  inherit (lib.types) enum nullOr;

  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPath = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];

  cfg = config.sylveon.system.loginManager;
  prof = config.sylveon.profiles;
in
{
  options.sylveon.system.loginManager = mkOption {
    type = nullOr (enum [ "greetd" ]);
    default = if prof.graphical.enable then "greetd" else null;
    description = "The login manager used by the system";
  };

  config = {
    services.greetd = mkIf (cfg == "greetd") {
      enable = true;

      settings = {
        default_session = {
          user = "greeter";
          command = concatStringsSep " " [
            (getExe pkgs.tuigreet)
            "--time"
            "--asterisks"
            "--sessions '${sessionPath}'"
          ];
        };
      };
    };
  };
}
