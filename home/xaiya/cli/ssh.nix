{ osConfig, ... }:
{
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

      "apricot" = {
        user = "gitlab";
        hostname = "apricot";
        identityFile = osConfig.age.secrets."ssh-gl-xy".path;
      };
    };
  };
}
