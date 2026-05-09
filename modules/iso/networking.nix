{ lib, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  # allow ssh into the system for headless installs
  systemd.services.sshd.wantedBy = mkForce [ "multi-user.target" ];
}
