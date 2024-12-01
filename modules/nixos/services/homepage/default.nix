{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  specialArgs,
  ...
}:
with lib;
let
    cfg = config.${namespace}.services.homepage;
in
{
    options.${namespace}.services.homepage = {
        enable = mkEnableOption "Create a personalized homepage with yall the services on the server!";

    };

    # Homepage is not in a docker container because the configuration here is easier then in docker
    config = mkIf cfg.enable {
       services.homepage-dashboard = {
          enable = true;
          listenPort = 3000;

          settings = {
            title = ''Xaiya's Void'';
            headerStyle = ''clean'';

            color = ''gray'';
            background = {
              image = ''https://images.unsplash.com/photo-1689351060804-fca36e095da4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1632&q=80'';
              blur = ''sm'';
            };

            layout = {
              "Development" = {
                style = ''row'';
              };
            };
          };

          widgets =
          [
            {
             resources = {
                label = ''System'';
                cpu = true;
                memory = true;
                uptime = true;
              };
            }

            {
             resources = {
                label = ''Disks'';
                disk = [ "/" "/mnt/raid" ];
              };
            }

            {
              search = {
                provider = [''google'' ''duckduckgo''];
                focus = true;
                target = ''_blank'';
              };
            }

            {
              datetime = {
                text_size = ''x1'';

                format = {
                  dateStyle = ''short'';
                  timeStyle = ''short'';
                  hourCycle = ''h23'';
                };
              };
            }
          ];

         services =
         [
           {
              "Services" = [
                {
                  "Firefly 3" = {
                    href = ''https://cash.semiko.dev'';
                    icon = ''firefly'';
                    description = ''Finance managment software'';
                  };
                }

                {
                  "Vaultwarden" = {
                    href = ''https://vault.semiko.dev'';
                    icon = ''vaultwarden'';
                    description = ''Password Manager Service'';
                  };
                }
              ];
           }

           {
             "Local & External" = [
               {
                 "Fritz!Box" = {
                   href = ''http://192.168.1.1'';
                   icon = ''avmfritzbox'';
                   description = ''Router configuration interface'';
                   widget = {
                     type = "fritzbox";
                     url = "http://192.168.1.1/";
                   };
                   ping = "http://192.168.1.1/";
                 };
               }
             ];
           }
         ];
      };

      networking.firewall.allowedTCPPorts = [ 3000 ];
      services.nginx.virtualHosts."semiko.dev" = {
          forceSSL = true;
          useACMEHost = "semiko.dev";

          serverAliases = [ "www.semiko.dev" ];
          locations."/".proxyPass = "http://[::1]:3000";
          extraConfig = "proxy_ssl_server_name on;";
      };
    };
}
