{ lib, inputs, }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) package bool;
  inherit (lib) mkIf forEach mkMerge;

  # Simplified one lining mkOption
  # example: ``mkOpt str "" "Example Option"``
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  # funtion to generelize service stuff
  # proxy: { domain; port OR socket OR locations }
  # secrets: [{ name; (optional) owner; (optional) script; (optional) mode; }]
  # databases: [ name ]
  # transparent
  mkService = { proxy ? null, secrets ? null, databases ? null }: transparent: {

    age.secrets = (mkIf secrets (forEach secrets (x: {
      
      # Secrets
      ${x.name} = mkMerge [
        { 
          inherit (x) mode;
          rekeyFile = "${inputs.self}/secrets/${x}.age";
        }

        (mkIf x.script { generator.script = x.script; })

        (mkIf x.owner {
          inherit (x) owner;
          group = x.owner;
        })
      ];
    })));


    services = {
      # Databases
      postgresql = (mkIf databases {
        ensureDatabases = databases;

        ensureUsers = 
          forEach databases (x: { name = x; ensureDBOwnership = true; });
      });
      
      # Proxy
      nginx.virtualHosts.${proxy.domain} = (mkIf proxy {
        enableACME = true;
        useACMEHost = "xaiya.dev";
        forceSSL = true;

        inherit (proxy) root;
        
        locations = 
          (if 
            (proxy.locations) then proxy.locations
          else {
            "/".proxyPass = 
              if proxy.socket then proxy.socket else "http://[::1]:${proxy.port}";
          });

        extraConfig = "proxy_ssl_server_name on;";
      });
    };
  };

in
{
  inherit 
    mkOpt 
    mkService
    ;
}
