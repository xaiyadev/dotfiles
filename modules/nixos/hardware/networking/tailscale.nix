{ lib, config, ... }:
let
  inherit (lib) mkIf;

  cfg = config.sylveon.networking;
in
{
  config = mkIf cfg.tailscale.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client"; # TODO: add server support

    };
  };
}