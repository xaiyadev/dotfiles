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



     /** Notes:
       * Way to use home-manager: https://www.reddit.com/r/NixOS/comments/txf3ok/comment/i3q9eco/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
       */
    minecraft-options = types.submodule {};
in
{

    options.${namespace}.programs.minecraft = {
      enable = mkEnableOption "install minecraft and configure it";
      package = mkOption {
        type = types.package;
        default = pkgs.minecraft;
        description = ''
          What minecraft launcher should be used.'';
      };

      options = mkOption {
        /** Important:
          * renderClouds needs to be a string!
         */
        type = with lib.types; attrsOf (nullOr (oneOf [ bool int str ]));

        example = lib.literalExpression ''
          autoJump = false;
          guiScale = 2;
          maxFps = 120;

          toggleSprint = true;
        '';

        description = ''
          The options.txt in the .minecraft folder
          all options can be seen here: https://minecraft.fandom.com/wiki/Options.txt
        '';

     };

     resourcepacks = mkOption {

     };

     lunar-client.enable = mkEnableOption ''If the Lunar Client should be activated'';

     lunar-client.package = mkOption {
       type = types.package;
       default = pkgs.lunar-client;
       description = ''The lunar-client package that should be used'';
     };

     lunar-client.launcher.settings = {
       type = with lib.types; attrsOf (nullOr (oneOf [ bool int str ])); /* TODO: needs in depth settings option */
       example = lib.literalExpression ''
         langueage = "en_US";
         afterLaunchAction = "HIDE";
       /*discordRichPresence = {
           enabled = true;
           hideWhenIdle = false;
         };*/
       '';

       description = ''the launcher.json in .lunarclient'';
     };

      lunar-client.launcher.profiles = { }; /* Has: profile name; has jsons for: settings/game/PROFILENAME/; */



    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [ lunar-client ];


    };
}