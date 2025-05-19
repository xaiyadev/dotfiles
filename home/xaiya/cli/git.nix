{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Xaiya Schumin";
    userEmail = "d.schumin@proton.me";

    extraConfig = {
      push.autoSetupRemote = true;

      commit.gpgsign = true;
    };
  };
}
