{ pkgs, ... }: {

  home.file.".ssh/allowed_signers".text =
    "* ${builtins.readFile /home/nelson/.ssh/id_ed25519.pub}";


    programs.git = {
        enable = true;
        package = pkgs.gitFull;
        userName = "Danil Schumin";
        userEmail = "d.schumin@blmedia.de"; # TODO: add an option to change
    };

    extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
    };

    init.defaultBranch = "master";
}