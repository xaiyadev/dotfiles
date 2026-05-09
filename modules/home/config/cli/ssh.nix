{ osConfig, lib, ... }:
let
  inherit (lib) mkIf;
in
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

      "github.com" = mkIf (builtins.hasAttr "ssh-github" osConfig.age.secrets) {
        user = "git";
        hostname = "github.com";
        identityFile = osConfig.age.secrets."ssh-github".path;
      };

      "apricot" = mkIf (builtins.hasAttr "ssh-tangled" osConfig.age.secrets) {
        user = "git";
        hostname = "apricot"; # change it to: knot.xaiya.dev TODO
        identityFile = osConfig.age.secrets."ssh-tangled".path;
      };
    };
  };
}
