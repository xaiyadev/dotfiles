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

  options.sylveon.cli.git = mkPackageOpt pkgs.gitFull "Whether or not to install and configure kitty";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      inherit (cfg) package;

      settings = {
        user = {
          name = "Xaiya Schumin";
          email = "d.schumin@proton.me";
        };

        push.autoSetupRemote = true;
        commit.gpgsign = true;
      };
    };
  };
}
