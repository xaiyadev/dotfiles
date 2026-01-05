{
  inputs,
  lib,
  self,
  config,
  ...
}:

let
  inherit (lib)
    mkIf
    mkForce
    mkMerge
    forEach
    ;

  inherit (lib.strings)
    splitString
    ;

  inherit (lib.lists)
    last
    ;

  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt;
  cfg = config.sylveon.programs.discord;
  nixcordcfg = config.programs.nixcord.config;
in
{
  options.sylveon.programs.discord.enable = mkOpt bool false "Whether or not to enable discord";

  imports = [ inputs.nixcord.homeModules.nixcord ];

  config = mkIf cfg.enable {
    programs.nixcord = {
      enable = true;
      discord = {
        vencord.enable = mkForce false;
        equicord.enable = true;
      };

      config = {
        # Themes based on files is currently bugged with equicord (TODO)
        themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha-flamingo.theme.css" ];
        transparent = true;

        # Activate and Configure Plugins
        plugins = {
          alwaysExpandRoles.enable = true;
          anonymiseFileNames.enable = true;
          biggerStreamPreview.enable = true;
          betterGifPicker.enable = true;
          betterSessions.enable = true;
          betterSettings.enable = true;
          BlurNSFW.enable = true;
          callTimer.enable = true;
          ClearURLs.enable = true;
          CopyUserURLs.enable = true;
          disableCallIdle.enable = true;
          dontRoundMyTimestamps.enable = true;
          favoriteEmojiFirst.enable = true;
          favoriteGifSearch.enable = true;
          fixCodeblockGap.enable = true;
          fixImagesQuality.enable = true;
          friendsSince.enable = true;
          fullSearchContext.enable = true;

          memberCount = {
            enable = true;
            memberList = false;
          };

          mentionAvatars.enable = true;
          # messageLogger.enable = true;
          noMaskedUrlPaste.enable = true;
          noUnblockToJump.enable = true;
          openInApp.enable = true;
          permissionFreeWill.enable = true;
          permissionsViewer.enable = true;
          plainFolderIcon.enable = true;

          platformIndicators = {
            enable = true;
            list = false;
            messages = false;
          };

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
