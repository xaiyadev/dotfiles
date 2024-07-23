{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.chromium;
in
{
    options.services.chromium = {
        enable = mkEnableOption "custom chromium service";

        installEnpass = mkOption {
            type = types.bool;
            default =  false;
        };
    };

    config = mkIf cfg.enable {
        programs.chromium = {
            enable = true;

            extensions = [
               { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
               { id = "oldceeleldhonbafppcapldpdifcinji"; }# Language Tool
               { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin

               { id = "kmcfomidfpdkfieipokbalgegidffkal"; } # enpass
            ];

            dictionaries = with pkgs.hunspellDictsChromium; [
                en_US
                de_DE
            ];
        };
    };
}