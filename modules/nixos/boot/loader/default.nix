{ lib, self, ... }:
let
  inherit (self.lib.modules) mkOpt nullOr;
  inherit (lib.types) enum;
in
{
  imports = [
    ./grub.nix
  ];

  options.sylveon.system.boot.loader =
    mkOpt (nullOr (enum [ "grub" ])) null "What bootloader the device should use.";
}