{ lib, ... }:
let
  inherit (lib.modules) mkForce mkAfter;
in
{
  boot = {
    kernelParams = mkAfter [
      "noquiet"
      "toram"
    ];

    swraid.enable = mkForce false;
    supportedFilesystems.zfs = false;
  };
}