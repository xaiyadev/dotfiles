{ lib, self, config, pkgs, ... }:
let
  inherit (lib)
    mkIf
    concatStringsSep
    getExe
    ;

  inherit (lib.types) enum nullOr;
  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.system.loginManager;
  prof = config.sylveon.profiles;
in
{
  options.sylveon.system.loginManager =
    mkOpt (
      nullOr (enum [ "greetd" "gdm" ]))
      (if prof.graphical.enable then "greetd" else null)
      "The login manager used by the system";

  config = {
    services.greetd = mkIf (cfg == "greetd") {
      enable = true;
      restart = true;
      vt = 2;

      settings = {
        default_session = {
          user = "greeter";
          command = concatStringsSep " " [
            (getExe pkgs.greetd.tuigreet)
              "--time"
              "--asterisks"
              "--cmd '${pkgs.swayfx}/bin/sway'" # TODO: temporary solution
          ];
        };
      };
    };
  };
}