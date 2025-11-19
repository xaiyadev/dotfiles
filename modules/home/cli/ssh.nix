{ osConfig, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; # Option will be deprecated

    # Default Matchblocks that should be on every System
    # This might change over time if any other (not me) person joins this flake
    matchBlocks = {
      "*" = {
        addKeysToAgent = "no"; # These SSH Keys do not need to be managed through an agent

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

      "apricot" = {
        user = "gitlab";
        hostname = "apricot";
        identityFile = osConfig.age.secrets."ssh-tangled".path;
      };
    };
  };
}
