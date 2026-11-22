{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.services.pds;
  pds = config.services.tranquil-pds;

  hostname = "pds.xaiya.dev";
in
{

  options.sylveon.services.pds.enable = mkEnableOption "ATProtocol Personal Data Server";

  config = mkIf cfg.enable {
    # generating the JWT_SECRET DPOP_SECRET and MASTER_KEY
    age.secrets.pds-env = {
      rekeyFile = "${self}/secrets/pds.env.age";
      generator.script =
        { pkgs, ... }:
        ''
          for var in JWT_SECRET DPOP_SECRET MASTER_KEY; do
            echo "$var=$(${pkgs.openssl}/bin/openssl rand -base64 48)"
          done
        '';
    };

    # own cert for the pds
    security.acme.certs.${hostname}.extraDomainNames = [ "*.${hostname}" ];

    services = {
      tranquil-pds = {
        enable = true;

        database.createLocally = true;
        environmentFiles = [ config.age.secrets.pds-env.path ];

        settings = {
          server = {
            inherit hostname;

            trusted_proxy_count = 1;

            # no mail server yet -> cant verify
            # TODO: remove once email is configured 
            disable_account_verification_gate = true;
          };

          # TODO: configure a mail-server
          # email = { };
        };
      };

      nginx.virtualHosts.${hostname} = {
        useACMEHost = hostname;
        forceSSL = true;

        serverAliases = [ "*.${hostname}" ];

        locations =
          let
            proxyPass = "http://${pds.settings.server.host}:${toString pds.settings.server.port}";
          in
          {
            "/" = {
              inherit proxyPass;
              recommendedProxySettings = true;
            };

            # firehose (subscribeRepos) is a long living websocket
            "/xrpc/" = {
              inherit proxyPass;
              proxyWebsockets = true;
              recommendedProxySettings = true;

              extraConfig = ''
                proxy_buffering    off;
                proxy_read_timeout 86400s;
                proxy_send_timeout 86400s;
              '';
            };

            "/oauth/" = {
              inherit proxyPass;
              recommendedProxySettings = true;

              extraConfig = ''
                proxy_read_timeout 300s;
                proxy_send_timeout 300s;
              '';
            };
          };

        extraConfig = ''
          client_max_body_size 10G; # matches the default max_blob_size
          proxy_ssl_server_name on;
        '';
      };
    };

    # the hardened unit only allows writes to the blob dir; allow writing to it
    systemd.services.tranquil-pds.serviceConfig.ReadWritePaths = [ pds.dataDir ];
  };
}
