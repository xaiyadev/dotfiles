
{ config, lib, pkgs, modulesPath, ... }:
with lib;
let
    cfg = config.services.git;
    sshdPort = 8888;
    softServePort = 22;
in
{
    options.services.git = {
        enable = mkEnableOption "custom git service";
    };

    config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [sshdPort softServePort];
      services.openssh.ports = [sshdPort];

      environment.systemPackages = with pkgs; [ soft-serve ];

      users.users.git = {
          isSystemUser = true;
          initialPassword = "git";
          description = "Git Server";
          extraGroups = [ "networkmanager" "git" ];
      };

      services.soft-serve = {
          enable = true;

          settings = {
            name = "Semiko Git Server";
            log_format = "json";

            ssh = {
                listen_addr = ":23231";
                public_url = "ssh://git.semiko.dev";
                max_timeout = 30;
                idle_timeout = 120;
            };

            http.listen_addr = "2508";
          };
      };

      services.nginx.virtualHosts."git.semiko.dev" = {
          addSSL = true;
          enableACME = true;
          locations."/".proxyPass = "http://127.0.0.1:23231";

      };
  };
}