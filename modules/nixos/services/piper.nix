{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib.modules) mkServiceOpt;

  cfg = config.sylveon.services.piper;
in
{

  options.sylveon.services.piper =
    mkServiceOpt "piper" { port = 3015; domain = "piper.xaiya.dev"; };

  config = mkIf cfg.enable {
    # Create secrets
    age.secrets.piper-env.rekeyFile = "${self}/secrets/piper-env.age";

    services = {
      piper = {
        enable = true;
        environmentFiles = [ config.age.secrets.piper-env.path ];

        settings = {
          SERVER_PORT = cfg.port;
          SERVER_HOST = "localhost";
          SERVER_ROOT_URL = "https://${cfg.domain}";

          ENABLE_SPOTIFY = false;
          ENABLE_LASTFM = true; # Only for migration purposes
        };
      };

      # Create proxy entry
      nginx.virtualHosts.${cfg.domain} = {
        locations."/".proxyPass = "http://localhost:${builtins.toString cfg.port}";
      };
    };
  };
}
