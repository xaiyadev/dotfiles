{ inputs, lib, self, config, ... }:

let
    inherit (lib)
      mkIf
      mkForce
      ;

    inherit (lib.types) bool;

    inherit (self.lib.modules) mkOpt;
    cfg = config.sylveon.programs.discord;
in
{
  options.sylveon.programs.discord.enable =
    mkOpt bool false "Whether or not to enable discord";

  imports = [ inputs.nixcord.homeModules.nixcord ];

  config = mkIf cfg.enable {
    programs.nixcord = {
      enable = true;
      discord.enable = true;

      config = {

        # Activate and Configure Plugins
        plugins = {
          alwaysExpandRoles.enable = true;
          anonymiseFileNames.enable = true;
          biggerStreamPreview.enable = true;
          betterGifPicker.enable = true;
          betterSessions.enable = true;
          betterSettings.enable = true;
          blurNSFW.enable = true;
          callTimer.enable = true;
          clearURLs.enable = true;
          copyUserURLs.enable = true;
          disableCallIdle.enable = true;
          dontRoundMyTimestamps.enable = true;
          favoriteEmojiFirst.enable = true;
          favoriteGifSearch.enable = true;
          fixCodeblockGap.enable = true;
          fixImagesQuality.enable = true;
          friendsSince.enable = true;
          fullSearchContext.enable = true;
          memberCount = { enable = true; memberList = false; };
          mentionAvatars.enable = true;
          messageLogger.enable = true;
          noMaskedUrlPaste.enable = true;
          noUnblockToJump.enable = true;
          openInApp.enable = true;
          permissionFreeWill.enable = true;
          permissionsViewer.enable = true;
          plainFolderIcon.enable = true;
          platformIndicators = { enable = true; lists = false; messages = false; };
          serverInfo.enable = true;
          showAllMessageButtons.enable = true;
          showHiddenChannels.enable = true;
          showHiddenThings.enable = true;
          typingIndicator.enable = true;
          typingTweaks.enable = true;
          viewIcons.enable = true;
          volumeBooster.enable = true;
          whoReacted.enable = true;
          youtubeAdblock.enable = true;
        };
      };
    };
  };
}
