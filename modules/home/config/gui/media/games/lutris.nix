{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.lists) any;

  clients = config.sylveon.programs.game-clients;
in
{
  config = mkIf (clients != null && any (x: x == "lutris") clients) {
    programs.lutris = {
      enable = true;

      steamPackage = pkgs.steam; # configured in ./steam.nix

      protonPackages = [ pkgs.proton-ge-bin ];
      defaultWinePackage = pkgs.proton-ge-bin;

      runners = {
        dolphin.package = pkgs.dolphin-emu;
        rpcs3.package = pkgs.rpcs3;
        # TODO: add switch/nintendo emulator + pico-8
      };
    };
  };
}
