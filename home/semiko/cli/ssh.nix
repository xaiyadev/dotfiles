{ osConfig, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = { /* https://mynixos.com/home-manager/option/programs.ssh.enableDefaultConfig */
        compression = true; 
        hashKnownHosts = true; 
        userKnownHostsFile = "~/.ssh/known_hosts"; 
        controlPath = "~/.ssh/master-%r@%n:%p"; 
      };

      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = osConfig.age.secrets."ssh-gh".path;
        hashKnownHosts = true;
      };
    };
  };
}
