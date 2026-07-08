{ pkgs, osConfig, ... }:
{

  programs = {
    git = {
      enable = true;
      package = pkgs.gitMinimal;

      settings = {
        user = {
          name = "Xaiya Schumin";
          email = "d.schumin@proton.me";
        };

        push.autoSetupRemote = true;
        commit.gpgsign = osConfig.sylveon.hardware.yubikey; # only sign with gpg if the system can read my yubikey

        init.defaultBranch = "master";
        color.ui = "auto";

        fetch.prune = true;

        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
        };

        branch = {
          autosetupmerge = "true";

          # sorts branches so the newest ones by latest commit are at the top
          sort = "committerdate";
        };

        pull = {
          default = "current";
          ff = "only";
        };
      };
    };

    # pager / diff tool
    delta = {
      enable = true;
      enableGitIntegration = true;

      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
      };
    };
  };
}
