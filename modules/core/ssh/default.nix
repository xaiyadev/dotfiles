{ config, lib, ... }:
with lib;
let
    cfg = config.services.ssh;
in
{
    options.services.ssh = {
        enable = mkEnableOption "custom ssh service";
    };

    config = mkIf cfg.enable {
        services.openssh = {
            enable = true;
            banner = " Welcome to Breakings System! ";
        };

        programs.ssh.extraConfig = "
        HOST github.com
            PreferredAuthentications publickey
            IdentityFile ~/.ssh/git_ssh_key

         HOST bitbucket.org
            PreferredAuthentications publickey
            IdentityFile ~/.ssh/bitbucket_ssh_key";


   };
}