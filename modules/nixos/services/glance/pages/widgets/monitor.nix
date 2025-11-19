{ lib, config, ... }:
let
  inherit (lib) forEach attrsToList;
in
{
  type = "monitor";
  cache = "30s";
  title = "Services";

  # Automaticly create the sites based on domains passing through nginx
  sites = 
    forEach 
      (attrsToList config.services.nginx.virtualHosts) 
      (x: {
        title = 
          builtins.elemAt (builtins.split "(.)xaiya.dev" x.name) 0;

        url = "https://${x.name}";
      });
}
