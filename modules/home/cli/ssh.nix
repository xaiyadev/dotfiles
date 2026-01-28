{ osConfig, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        serverAliveCountMax = 3;

        hashKnownHosts = true; 
        userKnownHostsFile = "~/.ssh/known_hosts"; 

        controlPath = "~/.ssh/master-%r@%n:%p"; 
        controlPersist = "no";
      };
      
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = osConfig.age.secrets."ssh-gh".path;
      };

      "apricot" = { # TODO: manage it into: knot.xaiya.dev
        user = "git";
        hostname = "apricot";
        identityFile = osConfig.age.secrets."ssh-tangled".path;
      };
    };
  };
}
