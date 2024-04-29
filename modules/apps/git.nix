{ lib, pkgs, config, ...}:
with lib;
let
    cfg = config.services.gitService;
in {
    options.services.gitService = {
        enable = mkEnableOption "Choose what git Service you want to use";
        service = mkOption {
            type = types.str;
            default = "gitlab";
        };
    };


    config = mkIf (cfg.enable) {
           programs.git.enable = true;
           package = pkgs.gitFull;

           programs.git = if (cfg.service == "gitlab") then {
                userName = "Danil Schumin";
                userEmail = "danil80sch@gmail.com";

                extraConfig = {
                   commit.gpgsign = true;
                   gpg.format = "ssh";
                   user.signingkey = "~/.ssh/gitlab_ssh_key.pub";
               };

            } else {
                enable = true;
                package = pkgs.gitFull;
                userName = "Danil Schumin";
                userEmail = "d.schumin@blmedia.de";

                extraConfig = {
                    commit.gpgsign = true;
                    gpg.format = "ssh";
                    user.signingkey = "~/.ssh/bitbucket_ssh_key.pub";
                };
           };

    };
}
