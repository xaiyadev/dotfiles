{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Danil Schumin";
    userEmail = "d.schumin@blmedia.de";

    extraConfig = {
      push.autoSetupRemote = true;

      #commit.gpgsign = true; TODO: temp
    };
  };
}
