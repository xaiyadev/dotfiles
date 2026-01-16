{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib.modules) mkServiceOpt;

  cfg = config.sylveon.services.radicale;
in
{

  options.sylveon.services.radicale =
    mkServiceOpt "piper" { port = 5232; domain = "cal.xaiya.dev"; };

  config = mkIf cfg.enable {
    services = {
      radicale = {
        enable = true;
        settings = {
          server.hosts = [ "0.0.0.0:${builtins.toString cfg.port}" "[::]:${builtins.toString cfg.port}" ];
          auth = {
            type = "htpasswd";
            htpasswd_filename = "/mnt/raid/services/radicale/users";

            htpasswd_encryption = "bcrypt";
          };

          storage = {
            filesystem_folder = "/mnt/raid/services/radicale/collections";
          };
        };
      };


      nginx.virtualHosts.${cfg.domain} = {
        enableACME = true;
        forceSSL = true;

        locations."/radicale/" = {
          proxyPass = "http://${cfg.host}:${builtins.toString cfg.port}/";

          extraConfig = ''
            proxy_set_header X-Script-Name /radicale;
            proxy_pass_header Authorization;

            proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header  X-Remote-User $remote_user;
            proxy_set_header  Host $host;
          '';
        };
      };
    };
  };
}
