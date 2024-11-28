{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  specialArgs,
  ...
}:
with lib;
with lib.${namespace};
let
    cfg = config.${namespace}.apps.discord;
in
{
  options.${namespace}.apps.discord = with types; {
      enable = mkBoolOpt false "Wheter or not to install vesktop declerative";
  };

  config = mkIf cfg.enable {
    programs.nixcord = {
      enable = true;

      # Replace the discord package with vesktop
      discord = disabled;
      vesktop = enabled;

      config = {
        # Install and activate the rose-pine theme
        themeLinks = [ "https://raw.githubusercontent.com/rose-pine/discord/refs/heads/main/rose-pine.theme.css" ];
        enabledThemes = [ "rose-pine.theme.css" ];

        # Activate and Configure Plugins
        plugins = {
          alwaysExpandRoles = enabled;
          anonymiseFileNames = enabled;
          biggerStreamPreview = enabled;
          betterGifPicker = enabled;
          betterSessions = enabled;
          betterSettings = enabled;
          blurNSFW = enabled;
          callTimer = enabled;
          clearURLs = enabled;
          copyUserURLs = enabled;
          disableCallIdle = enabled;
          dontRoundMyTimestamps = enabled;
          favoriteEmojiFirst = enabled;
          favoriteGifSearch = enabled;
          fixCodeblockGap = enabled;
          fixImagesQuality = enabled;
          fixSpotifyEmbeds = enabled;
          fixYoutubeEmbeds = enabled;
          forceOwnerCrown = enabled;
          friendsSince = enabled;
          fullSearchContext = enabled;
          iLoveSpam = enabled;
          imageLink = enabled;
          memberCount = { enable = true; memberList = false; };
          mentionAvatars = enabled;
          messageLogger = enabled;
          noMaskedUrlPaste = enabled;
          noUnblockToJump = enabled;
          openInApp = enabled;
          permissionFreeWill = enabled;
          permissionsViewer = enabled;
          plainFolderIcon = enabled;
          platformIndicators = { enable = true; lists = false; messages = false; };
          relationshipNotifier = enabled;
          secretRingToneEnabler = enabled;
          serverInfo = enabled;
          showAllMessageButtons = enabled;
          showHiddenChannels = enabled;
          showHiddenThings = enabled;
          typingIndicator = enabled;
          typingTweaks = enabled;
          viewIcons = enabled;
          volumeBooster = enabled;
          whoReacted = enabled;
          youtubeAdblock = enabled;

          /* Vesktop exclusive */
          webKeybinds = enabled;
          webScreenShareFixes = enabled;
        };
      };
    };
  };
}
