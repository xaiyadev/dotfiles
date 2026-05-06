{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.system.networking.tailscale;
in
{

  options.sylveon.system.networking.tailscale = {
    enable = mkEnableOption "Tailscale VPN" // {
      default = true;
    };
  };

  config = {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client"; # TODO: add server support
    };
  };
}