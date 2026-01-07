{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib.modules) mkServiceOpt;

  cfg = config.sylveon.services.glance;
in
{

  options.sylveon.services.glance = 
    mkServiceOpt "Glance dashboard" { port = 8002; domain = "xaiya.dev"; };

  config = mkIf cfg.enable {
    age.secrets.glance-env.rekeyFile = "${self}/secrets/glance-env.age";

    services = {
      glance = {
        enable = true;
        openFirewall = false; # Managed through nginx server
        
        environmentFile = config.age.secrets.glance-env.path;
        
        settings = {
          pages = [
            (import ./pages/overview.nix { config = config; lib = lib; })
          ];
        
          server = {
            host = ""; # Needs to be an empty string, otherwise interfaces cant be found correctly
            port = cfg.port;
            proxied = true;
          };
        
          # rose-pine color theme TODO
          theme = {
            constrat-multiplier = 1.3;
            background-color = "249 22 12"; # Base
            pirmary-color = "245 50 91"; # Text
            positive-color = "2 55 83"; # Rose
            negative-color = "343 76 68"; # Love
          };
        };
      };

    
      # Enable proxy
      nginx.virtualHosts.${cfg.domain} = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://${cfg.host}:${builtins.toString cfg.port}";
          proxyWebsockets = true;
        };

        extraConfig = "proxy_ssl_server_name on;";
      };

    };
  };
}
