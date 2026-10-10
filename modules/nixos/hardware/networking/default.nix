{ lib, ... }:
let
  inherit (lib) mkForce;
in
{

  imports = [
    ./networkmanager.nix
    ./openssh.nix
    ./tailscale.nix
    ./systemd.nix
  ];

  networking = {
    # TODO: extend/work more on it?
    # global dhcp has been deprecated upstream, so we use networkd instead
    # however individual interfaces are still managed through dhcp in hardware configurations
    useDHCP = mkForce false;
    useNetworkd = mkForce true;

    # anytype configuration TODO (add option to check if enabled in home config/enabled configuration)
    firewall.allowedUDPPorts = [ 5353 38787 ];
    firewall.allowedTCPPorts = [ 38787 ];

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
}
