{ config, lib, self, pkgs, ... }:
let
  inherit (lib)
    mkIf
    mkMerge
    ;

  inherit (self.lib.modules)
    mkPackageOpt
    ;

    jsonOutputDrv = file:
      pkgs.runCommand
        "from-yaml"
        { nativeBuildInputs = [ pkgs.remarshal ]; }
       ''${pkgs.remarshal}/bin/remarshal -if yaml -i "${file}" -of json -o "$out"'';

  fromYAML = builtins.fromJSON (builtins.readFile jsonOutputDrv);

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

      settings = mkMerge [
        {
          server = {
            host = ""; /* Needs to be an empty string, otherwise interfaces cant be found correctly */
            port = 8002;
            proxied = true;
          };

          /* rose-pine theme */
          theme = {
            constrat-multiplier = 1.3;
            background-color = "249 22 12";
            pirmary-color = "245 50 91";
            positive-color = "247 23 15";
            negative-color = "248 15 61";
          };
        }

        fromYAML ./default.yaml

      ];
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
