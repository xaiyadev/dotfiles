{ inputs, lib, self, config, ... }: 
let
  inherit (lib) mkMerge mkIf;
  inherit (lib.types) str;
  inherit (self.lib.modules) mkServiceOpt mkOpt;

  cfg = config.sylveon.services.atprotocol.tangled;
in
{

  imports = [ 
    inputs.tangled.nixosModules.knot
    inputs.tangled.nixosModules.spindle
  ];

  options.sylveon.services.atprotocol.tangled = {
    owner = mkOpt str "did:plc:mycafjhyplj5z7a6qi5qjcil" "The owner of this tangled instance";

    knot = 
      mkServiceOpt "Tangled knot" { port = 5555; domain = "knot.xaiya.dev"; };

    spindle =
      mkServiceOpt "Tangled spindle" { port = 6555; domain = "spindle.xaiya.dev"; };
  };

  config = {
    services = mkMerge [
      (mkIf cfg.knot.enable {
        tangled.knot = {
          enable = true;
        
          server = {
            inherit (cfg) owner;
            hostname = cfg.knot.domain;
          };
        
          motd = ''
            >> Tangled Knot !! (owned by: ${config.services.tangled.knot.server.owner})
          '';
        };
        
        # Create proxy entry
        nginx.virtualHosts.${cfg.knot.domain} = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${cfg.knot.host}:${builtins.toString cfg.knot.port}";
            proxyWebsockets = true;
          };

          extraConfig = "proxy_ssl_server_name on;";
        };
      })

      (mkIf cfg.spindle.enable {
        tangled.spindle = {
          enable = true;

          server = {
            inherit (cfg) owner;
            hostname = cfg.spindle.domain;
          };
        };

 
        # Create proxy entry
        nginx.virtualHosts.${cfg.spindle.domain} = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${cfg.spindle.host}:${builtins.toString cfg.spindle.port}";
            proxyWebsockets = true;
          };

          extraConfig = "proxy_ssl_server_name on;";
        };
      })
    ];
  };
}
