{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  settingsFormat = pkgs.formats.json { };
  cfg = config.programs.discord;
in
{
  options.programs.discord = {
    moonlight = {
      enable = mkEnableOption "Discord with the moonlight client";

      settings = {
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

    xdg.configFile = {
      "moonlight-mod/stable.json".source =
        settingsFormat.generate "moonlight-settings.json" cfg.moonlight.settings;
    };
  };
}
