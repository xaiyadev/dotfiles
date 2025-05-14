{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Danil Schumin";
    userEmail = "d.schumin@blmedia.de";

    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_rsa"; # The git server that we use does not support security keys (blegh)
    };
  };
}