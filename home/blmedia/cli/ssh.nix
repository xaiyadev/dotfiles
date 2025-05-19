{ osConfig, ... }: {
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    compression = true;

    matchBlocks = {
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = osConfig.age.secrets."ssh-gh".path;
      };

      "bitbucket.org" = {
        user = "git";
        hostname = "bitbucket.org";
        identityFile = osConfig.age.secrets."ssh-bb".path;
      };
    };
  };
}