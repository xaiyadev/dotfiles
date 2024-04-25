{ pkgs, ... }: {
    programs.git = {
        enable = true;
        package = pkgs.gitFull;
        userName = "Danil Schumin";
        userEmail = "danil80sch@gmail.com"; # TODO: add an option to change

        extraConfig = {
            commit.gpgsign = true;
            gpg.format = "ssh";
            user.signingkey = "~/.ssh/gitlab_ssh_key.pub";
        };
    };


}
