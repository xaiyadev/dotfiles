{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.services.nginx;
in
{

  options.sylveon.services.nginx.enable = mkEnableOption "Enable Nginx proxy";

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;

      # create a redirect to my bsky as long as I dont have any services running
      virtualHosts."xaiya.dev".globalRedirect = "https://bsky.app/profile/xaiya.dev";
    };
  };
}
