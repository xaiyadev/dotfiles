{
  pkgs,
  modulesPath,
  lib,
  ...
}: let
     sshdPort = 8888;
     softServePort = 22;
in {
  networking.firewall.allowedTCPPorts = [sshdPort softServePort];
  services.openssh.ports = [sshdPort];

  environment.systemPackages = with pkgs; [
    alejandra
    duf
    git
    helix
    htop
    nil
    soft-serve
    tmux
    tree
  ];

  users.users.git = {
    isSystemUser = true;
    extraGroups = ["wheel"];
  };

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

  services.nginx.virtualHosts."cloud.semiko.dev" = {
      addSSL = true;
      enableACME = true;
  };

}