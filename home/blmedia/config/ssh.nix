{ osConfig, ... }:
{
  # Git login used only for work related things
  programs.ssh.matchBlocks."bitbucket.org" = {
      user = "git";
      hostname = "bitbucket.org";
      identityFile = osConfig.age.secrets."ssh-bb".path;
    };
}
