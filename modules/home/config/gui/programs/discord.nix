{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.sylveon.programs.discord;
in
{
  options.sylveon.programs.discord.enable =
    mkEnableOption "Whether or not to install the discord client";

  config = mkIf cfg.enable {
    programs.discord = {
      enable = true;
      settings = {
        SKIP_HOST_UPDATE = true;
        DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOUR_DOING = true;
        openasar = {
          setup = true;
          quickstart = true;
        };
      };

      moonlight = {
        enable = true;
        settings = {
          extensions = {
            betterCodeblocks = true;
            betterEmbedsYT = true;
            callTimer = true;
            clearUrls = true;
            cloneExpressions = true;
            disableSentry = true;
            domOptimizer = true;
            experiments = true;
            favouriteGifSearch = true;
            imageViewer = true;
            inviteToNowhere = true;
            memberCount = true;
            moonbase = true;
            nativeFixes = {
              enabled = true;
              config.vaapiIgnoreDriverChecks = true;
            };
            noReplyChainNag = true;
            noTrack = true;
            ownerCrown = true;
            pronouns = true;
            textReplacer = {
              enabled = true;
              config = {
                patterns = {
                  "://instagram.com/" = "://vxinstagram.com/";
                  "://reddit.com/" = "://rxddit.com/";
                  "://tiktok.com/" = "://tnktok.com/";
                  "://twitter.com/" = "://vxtwitter.com/";
                  "://vm.tiktok.com/" = "://vm.tnktok.com/";
                  "://www.instagram.com/" = "://vxinstagram.com/";
                  "://www.reddit.com/" = "://rxddit.com/";
                  "://x.com/" = "://vxtwitter.com/";
                };
              };
            };
          };

          repositories = [ "https://moonlight-mod.github.io/extensions-dist/repo.json" ];
        };
      };
    };
  };
}
