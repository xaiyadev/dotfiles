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
  # proxy: { domain; port OR socket }
  # secrets: [{ name; (optional) owner; (optional) script; (optional) mode; }]
  # databases: [ name ]
  # transparent
  mkService = 
    { 
      proxy ? null, 
      secrets ? null, 
      databases ? [], 
      transparent ? false 
    }: {



    # Write secrets if any secrets are given
    age.secrets = (mkIf (!builtins.isNull secrets) (forEach secrets (x: {
      
      ${x.name} = mkMerge [
        # A secret needs to have a name
        { rekeyFile = "${inputs.self}/secrets/${x.name}.age"; }

        (mkIf (builtins.hasAttr "mode" x) { mode = x.mode; })
        (mkIf (builtins.hasAttr "script" x) { generator.script = x.script; })

        (mkIf (builtins.hasAttr "owner" x) {
          inherit (x) owner;
          group = x.owner;
        })
      ];
    })));


    services = mkMerge [
      {
        # Create databases if given
        postgresql = {
          ensureDatabases = databases;

          ensureUsers = 
            forEach databases (x: { name = x; ensureDBOwnership = true; });
        };
      }

      (mkIf (proxy != null) {
        # create a (simple) nginx configuration
        nginx.virtualHosts.${proxy.domain} = {
            enableACME = true;
            useACMEHost = "xaiya.dev";
            forceSSL = true;
            
            locations."/".proxyPass = 
              if (builtins.hasAttr "socket" proxy) 
              then proxy.socket 
              else "http://[::1]:${proxy.port}";
            
            extraConfig = "proxy_ssl_server_name on;";
        };
      })

    ];
  };

in
{
  inherit 
    mkOpt 
    mkService
    ;
}
