{
  lib,
  config,
  inputs',
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.lists) any;

  clients = config.sylveon.programs.game-clients;
in
{
  config = mkIf (clients != null && any (x: x == "deadlock") clients) {
    # install mod-manager and the deadlock-api ingest client
    sylveon.packages = {
      grimoire = inputs'.grimoire.packages.default; 
      deadlock-api-ingest = inputs'.deadlock-api-ingest.packages.default;
    };

    # this service is run and needs to be configured in steam/grimoire
    # so that it runs and stops when deadlock starts up; Set this as the launch options:
    # systemctl --user start deadlock-api-ingest; %command%; systemctl --user stop deadlock-api-ingest
    systemd.user.services.deadlock-api-ingest = {
      Unit = {
        Description = "Deadlock API Ingest Service";
      };

      Service = {
        ExecStart = "${inputs'.deadlock-api-ingest.packages.default}/bin/deadlock-api-ingest";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  };
}
