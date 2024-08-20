{ pkgs, lib, config, ... }:
with lib;
let
    cfg = config.services.git;
in
{
    options.services.git = {
        enable = mkEnableOption "custom git service";
        email = mkOption {
            type = types.str;
            default = "danil80sch@gmail.com";
        };
    };

    config = mkIf cfg.enable {
       programs.git = {
         enable = true;
         package = pkgs.gitFull;
         userName = "Danil Schumin";
         userEmail = cfg.email;

         extraConfig = {
             commit.gpgsign = true;
             gpg.format = "ssh";
             user.signingkey = "~/.ssh/id_rsa.pub";
         };
       };
    };
}