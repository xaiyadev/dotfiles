{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  settingsFormat = pkgs.formats.json { };
  cfg = config.programs.discord;
in
{
  options.programs.discord = {
    moonlight = {
      enable = mkEnableOption "Discord with the moonlight client";

      settings = mkOption {
        inherit (settingsFormat) type;
        default = { };
        description = "Settings for the moonlight client";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.discord = {
      package = pkgs.discord.override {
        withMoonlight = cfg.moonlight.enable;
      };
    };

    # home-manager and discord are overlap each other and error out
    # with force we write the home-manager .bak file ontop of the discord .bak file
    home.file."${config.xdg.configHome}/${cfg.configName}/settings.json".force = true;

    xdg.configFile = {
      "moonlight-mod/stable.json".source =
        settingsFormat.generate "moonlight-settings.json" cfg.moonlight.settings;
    };
  };
}
