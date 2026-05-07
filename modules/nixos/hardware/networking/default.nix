{ lib, ... }:
let
  inherit (lib) mkForce;
in
{

  imports = [
    ./networkmanager.nix
    ./openssh.nix
    ./tailscale.nix
  ];

  networking = {
    # TODO: extend/work more on it?
    # global dhcp has been deprecated upstream, so we use networkd instead
    # however individual interfaces are still managed through dhcp in hardware configurations
    useDHCP = mkForce false;
    useNetworkd = mkForce true;

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
}
