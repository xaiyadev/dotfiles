{ osConfig, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  programs.ssh.settings."bitbucket.org ssh.bitbucket.org" = mkIf (builtins.hasAttr "ssh-bitbucket" osConfig.age.secrets) {
    user = "git";
    hostname = "ssh.bitbucket.org";
    identityFile = osConfig.age.secrets."ssh-bitbucket".path;
  };
}
