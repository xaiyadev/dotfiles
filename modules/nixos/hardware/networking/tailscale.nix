{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.sylveon.networking.tailscale;
in
{

  options.sylveon.networking.tailscale = {
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
