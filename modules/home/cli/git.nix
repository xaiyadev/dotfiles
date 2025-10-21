{
  pkgs,
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib.modules) mkPackageOpt;

  cfg = config.sylveon.cli.git;
in
{
  programs.git = {
    enable = true;

    # Could be moved to home (if git expands)
    settings = {
      user = {
        name = "Xaiya Schumin";
        email = "d.schumin@proton.me";
      };

      push.autoSetupRemote = true;
      commit.gpgsign = true;
    };
  };
}
