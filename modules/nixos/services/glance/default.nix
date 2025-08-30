{ config, lib, self, pkgs, ... }:
let
  inherit (lib)
    mkIf
    mkMerge
    ;

  inherit (self.lib.modules)
    mkPackageOpt
    ;

  cfg = config.sylveon.services.glance;
in
{

  options.sylveon.services.glance =
    mkPackageOpt pkgs.glance "Glance configuration (Dashboard)";

  config = mkIf cfg.enable {
    age.secrets.glance-env.rekeyFile = "${self}/secrets/glance-env.age";

    services.glance = {
      enable = true;
      openFirewall = false; /* Managed through nginx server */

      environmentFile = config.age.secrets.glance-env.path;

      settings = {
        pages = [
          (import ./pages/overview.nix)
        ];


        server = {
          host = ""; /* Needs to be an empty string, otherwise interfaces cant be found correctly */
          port = 8002;
          proxied = true;
        };

        /* rose-pine color theme */
        theme = {
          constrat-multiplier = 1.3;
          background-color = "249 22 12"; # Base
          pirmary-color = "245 50 91"; # Text
          positive-color = "2 55 83"; # Rose
          negative-color = "343 76 68"; # Love
        };
      };
    };


    /* All the configurations neede */

    services.nginx.virtualHosts."xaiya.dev" = {
        forceSSL = true;
        useACMEHost = "xaiya.dev";
        locations."/".proxyPass = "http://[::1]:8002";

        extraConfig = "proxy_ssl_server_name on;";
      };
  };

}
