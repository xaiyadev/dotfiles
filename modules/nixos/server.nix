{ lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.sylveon.profiles.server.enable {
    # echo the url instead of opening a browser when on a server;
    environment.variables.BROWSER = "echo";

    systemd = {
      enableEmergencyMode = false;
      sleep.settings.Sleep = {
        AllowSuspend = false;
        AllowHibernation = false;
      };
    };
  };
}
