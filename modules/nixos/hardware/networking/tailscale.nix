{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.sylveon.system.networking.tailscale;
in
{

  options.sylveon.system.networking.tailscale = {
    enable = mkEnableOption "Tailscale VPN" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client"; # TODO: add server support
    };
  };
}
