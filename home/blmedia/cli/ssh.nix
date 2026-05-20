{ osConfig, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  programs.ssh.settings."bitbucket.org" = mkIf (builtins.hasAttr "ssh-github" osConfig.age.secrets) {
    user = "git";
    hostname = "bitbucket.org";
    identityFile = osConfig.age.secrets."ssh-bitbucket".path;
  };
}
