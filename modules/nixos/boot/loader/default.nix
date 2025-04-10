{ lib, self, ... }:
let
  inherit (self.lib.modules) mkOpt;
  inherit (lib.types) enum;
in
{
  imports = [
    ./grub.nix
  ];

  options.sylveon.boot.loader =
    mkOpt (enum [ "grub" "none" ]) "none" "What bootloader the device should use.";
}