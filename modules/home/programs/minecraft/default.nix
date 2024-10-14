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
let
    cfg = config.${namespace}.programs.lunar-client;


    /* Notes: https://www.reddit.com/r/NixOS/comments/txf3ok/comment/i3q9eco/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button */
    minecraft-options = types.submodule {
      /* taken from my auto-generated config file. ~/.minecraft/options.txt */
      options = {
        version = mkOption {
          type = types.nullOr int;
          example = 3953; # Minecraft 1.21.1
          description =
            '' The Version the game is running on.
               !! This is the Data Version (3953) and not the Java Version (1.21.1) !!

               This helps the game understand what worlds you can enter.
               Dont change this unless you only play on one version only.

               for more information look at: https://minecraft.fandom.com/wiki/Data_version '';
        };

        ao = {
          type = types.nullOr bool;
          example = true;
          description =
            ''Should Smooth lightning be on or off'';
        };

        biomeBlendRadius = {
          type = types.nullOr int;
          example = 2;
          description =
            ''Radius for which biome blending should happen
              You should pick between a number of 0-7'';
        };

        enableVsync = {
          type = types.nullOr bool;
          example = true;
          description = '' Whether to enable v-sync (Vertical Synchronization) or not'';
        };

        entityDistanceScaling = {
          type = types.nullOr int;
          example = 1.0;
          description =
          '' The maximum Distance from the player that entites render
             You should choose a number between 0.5-5.0
          '';
        };

        entityShadows = {
          type = types.nullOr bool;
          example = true;
          description = '' If entity Shadows should be displayed or not'';
        };

        forceUnicodeFont = {
          type = types.nullOr bool;
          example = false;
          description = '' If Unicode font should be used or not '';
        };

        japaneseGlypVariants = {};

        fov = {
          type = types.nullOr int;
          example = 0.0;
          description =
          '' How large the fov (field of view) should be.
             How the fov is counted differs from the game way and the options.txt way
             You should choose a number between -1-1
          '';
        };

        fovEffectScale = {
          type = types.nullOr int;
          example = 1.0;
          description =
          '' How much the effects of FOV changes should be (sprinting; speed; slowness...)
             You should choose a number between 0-1
          '';
        };

        darknessEffectScale = {
          type = types.nullOr int;
          example = 1.0;
          description =
          '' How much the Darness Effect Pulses
             You should choose a number between 0-1
          '';
        };

        glintSpeed = {};
        glintStrength = {};

        prioritizeChunkUpdates = {
          type = types.nullOr int;
          example = 0;
          description =
            ''What chunk selection update strategy should be choosen
              you can pick between:
              0 = Threaded
              1 = Semi Blocking
              2 = Fully Blocking'';
        };

        fullscreen = {
          type = types.nullOr bool;
          example = false;
          description = '' If the game should be started as fullscreen '';
        };

        gamma = {
          type = types.nullOr int;
          example = 0.5;
          description =
          '' The Brightness of the game
             You should choose a number between 0-1
             NOTE: values below 0 and above 1 are invalid and inaccessible on vanilla
          '';
        };

        graphicsModel = {
          type = types.nullOr int;
          example = 1;
          description =
            '' Whether Fast (less detailed), Fancy (more detailed) or Fabulous! (most detailed) graphics should be choosen
               Pick between:
               0 = Fast
               1 = Fancy
               2 = Fabulous '';
        };

        guiScale = {
          type = types.nullOr int;
          example = 0;
          description =
          '' The interface sizes
             You should pick a number between 0 and an undefined number that is calculated with the screen resolution
             0 = auto
             1+ = size
          '';
        };

        maxFps = {
          type = types.nullOr int;
          example = 120;
          description =
            '' The maximum framerate
               you should pick a number between 10-260 '';
        };

        mimapLevel = {};
        narrator = {};

        particles = {
          type = types.nullOr int;
          example = 0;
          description =
          '' The amount auf particles (e.g rain; potion effects; etc)
             You should pick a number between 0 2
             0 = All
             1 = Decreased
             2 = Minimal '';
        };

        reducedDebugInfo = {
          type = types.nullOr bool;
          example = false;
          description = '' If the Debug Screen should show less information '';
        };

        renderClouds = {
          type = types.nullOr enum [ "true" "false" "fast" ];
          example = "true";
          description =
            ''Render Type of Clouds
              Choose between: true/false/fast'';
        };

        renderDistance = {
          type = types.nullOr int;
          example = 12;
          description =
            '' The render distance in the chunk radius from the player
               You should pick a number between 2-32 '';
        };

        simulationDistance = {
          type = types.nullOr int;
          example = 12;
          description =
            '' The simulation distance in the chunk radius from the player
               You should pick a number between 5-32 '';
        };

        screenEffectScale = {
          type = types.nullOr int;
          example = 1.0;
          description =
            '' Distoration Effects (Nausea and Nether Portal Effects)
               Pick a number between 0-1 '';
        };

        soundDevice = {
          type = types.nullOr str;
          description = ''The sound device that minecraft should use'';
        };

        autoJump = mkEnableOption {
          type = types.nullOr bool;
          example = true;
          description = '' Whether auto jump is enabled '';
        };

        operatorItemsTab = {};

        autoSuggestions = {
          type = types.nullOr bool;
          example = true;
          description =
          '' If commands (e.g /tp) should have autoSuggestions or if they only should show up if you press TAB '';
        };

        chatColors = {
          type = types.nullOr bool;
          example = true;
          description = ''If the chat is allowed to show color'';
        };

        chatLinks = {
          type = types.nullOr bool;
          example = true;
          description = '' Whether links should be created or links should be plaintext '';
        };

        chatLinksPrompt = {
          type = types.nullOr bool;
          example = true;
          description = '' Whether clicking the link needs confiration or not '';
        };

        discrete_mouse_scroll = {
          type = types.nullOr bool;
          example = false;
          description = '' Whether scrolling set by the operating system should be ignore or not'';
        };

        invertYMouse = {
          type = types.nullOr bool;
          example = false;
          description = ''Whether the mouse should be inverted or not'';
        };

        realmsNotifications = {
          type = types.nullOr bool;
          example = true;
          description = ''Whether Realms invites are alerted on the main menu'';
        };

        showSubtitles = {
          type = types.nullOr bool;
          example = false;
          description = ''If subtitles are shwon'';
        };

        directionalAudio = {
          type = types.nullOr bool;
          example = false;
          description = '' If directional Audio is enabled '';
        };

        touchscreen = {
          type = types.nullOr bool;
          example = false;
          description = ''If touchscreen controls should be used'';
        };

        bobView = {
          type = types.nullOr bool;
          example = true;
          description = '' Whether or not the camera bobs up and down as the player walks '';
        };

        toggleCrouch = {
          type = types.nullOr bool;
          example = false;
          description = ''If the sneak key should be pressed or held for sneaking'';
        };

        toggleSprint = {
          type = types.nullOr bool;
          example = false;
          description = ''If the sprint key should be pressed or held for sprinting'';
        };

        darkMojangStudiosBackground = {
          type = types.nullOr bool;
          example = false;
          description = '' Whether the Mojang Studios loading screen look monochrome '';
        };

        hideLightningFlashes = {
          type = types.nullOr bool;
          example = false;
          description = '' If Lightning effects should be hidden or not'';
        };

        hideSplashTexts = {};

        mouseSensitivity = {
          type = types.nullOr int;
          example = 0.5;
          description = '' The mouse Sensitivity. A number between 0-1 should be choosen '';
        };

        damageTiltStrength = {};
        highContrast = {};
        narratorHotkey = {};

        resourcePacks = {
          type = types.nullOr (listOf str);
          example = [];
          description = ''A list of active resource packs'';
        };

        incompatibleResourcePacks = {
          type = types.nullOr (listOf str);
          example = [];
          description = ''A list of active and incompatible (with the version) resource packs'';
        };

        lastServer = {
          type = types.nullOr str;
          example = "127.0.0.1";
          description = ''The last adress you used for direct Connection'';
        };

        lang = {
          type = types.nullOr str;
          example = "en_us";
          description = ''The language that should be used'';
        };

        chatVisibility = {
          type = types.nullOr int;
          example = 0;
          description =
            '' What is seen in the chat
               You can choose between:
               0 = Shown
               1 = Commands Only
               2 = Hidden '';
        };

        chatOpacity = {
          type = types.nullOr int;
          example = 1.0;
          description =
            '' The transparency of the chat
               You can choose between 0-1;'';
        };

        chatLineSpacing = {
          type = types.nullOr int;
          example = 0.0;
          description =
            '' Spacing between the chat
               You can choose between 0-1;'';
        };

        textBackgroundOpacity = {
          type = types.nullOr int;
          example = 0.5;
          description =
            '' The transparency of the text Background
               You can choose between 0-1;'';
        };

        backgroundForChatOnly = {
          type = types.nullOr bool;
          example = true;
          description =
            '' toggle if the background is only in chat or if it's everywhere '';
        };

        advancedItemTooltips = {
          type = types.nullOr bool;
          example = false;
          description =
            '' Whether hovering over items show an extended tooltip (F3+H) '';
        };

        pauseOnLostFocus = {
          type = types.nullOr bool;
          example = true;
          description =
            '' Whether the game should pause if you tab out of it '';
        };

        overrideWidth = {
          type = types.nullOr int;
          example = 0;
          description =
            '' The width in pixels in wich minecraft should start '';
        };

        overrideHeight = {
          type = types.nullOr int;
          example = 0;
          description =
            '' The height in wich minecraft should start '';
        };

        chatHeightFocused = {
          type = types.nullOr int;
          example = 0.4375;
          description =
            '' How tall the maximum chat span is, when the button is not pressed
               pick a number between 0-1'';
        };

        chatDelay = {};
        chatHeightUnfocused = {};

        chatScale = {
          type = types.nullOr int;
          example = 1.0;
          description =
            '' The scale/size of the text in the chat
               pick a number between 0-1'';
        };

        chatWidth = {
          type = types.nullOr int;
          example = 1.0;
          description =
            '' The span width of the chat
               pick a number between 0-1'';
        };

        notificationDisplayTime = {};

        useNativeTransport = {
          type = types.nullOr bool;
          example = true;
          description =
            '' I do not understando this '';
        };

        mainHand = {
          type = types.nullOr enum [ "left" "right" ];
          example = "right";
          description =
            '' What hands should be used '';
        };

        attackIndicator = {
          type = types.nullOr int;
          example = 1;
          description =
            '' When hitting how the attacker indicator is on screen
               pick a number between 0-2
               00 = Off
               01 = Crosshair
               02 = Hotbar'';
        };

        tutorialStep = {
          type = types.nullOr enum [ "movement" "find_tree" "punch_tre" "open_inventory" "craft_planks" "none" ];
          example = "movement";
          description =
            '' Next stage of tutrial hints on display '';
        };

        mouseWheelSensitivity = {
          type = types.nullOr int;
          example = 1.0;
          description =
            '' How sensitive should be the mouse wheel
               Pick a number between 1-10 '';
        };

        rawMouseInput = {};
        
        glDebugVerbosity = {};
        skipMultiplayerWarning = {};
        hideMatchedNames = {};
        joinedFirstServer = {};
        hideBundleTutorial = {};
        syncChunkWrites = {};
        showAutosaveIndicator = {};
        allowServerListing = {};
        onlyShowSecureChat = {};
        panoramaScrollSpeed = {};
        telemetryOptInExtra = {};
        onboardAccessibility = {};
        menuBackgroundBlurriness = {};
      };
    };
in
{

    options.${namespace}.programs.lunar-client = {
      enable = mkEnableOption "install minecraft and configure it";

      minecraft.options = mkOption {
       type = minecraft-options;

     };
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [ lunar-client ];


    };
}