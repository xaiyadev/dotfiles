{ pkgs, lib, self, config, ... }:
let
  inherit (lib) mkIf;
  inherit (self.lib.modules) mkPackageOpt;

  cfg = config.sylveon.cli.git;
in
{

  options.sylveon.cli.git =
    mkPackageOpt pkgs.gitFull "Whether or not to install and configure kitty";

  config = {
    programs.git = {
      inherit (cfg) enable package;

      userName = "Xaiya Schumin";
      userEmail = "d.schumin@proton.me";

      extraConfig = {
        push.autoSetupRemote = true;

        commit.gpgsign = true;
      };
    };
  };
}