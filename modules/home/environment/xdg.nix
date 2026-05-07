{ config, ... }:
let
  inherit (config.home) homeDirectory;
in
{
  xdg = {
    enable = true;

    cacheHome = "${homeDirectory}/.cache";
    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
    stateHome = "${homeDirectory}/.local/state";

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;

      documents = "${homeDirectory}/documents";
      download = "${homeDirectory}/downloads";
      desktop = "${homeDirectory}/desktop";
      videos = "${homeDirectory}/documents/media/videos";
      music = "${homeDirectory}/documents/media/music";
      pictures = "${homeDirectory}/documents/media/pictures";
      publicShare = "${homeDirectory}/public/share";
      templates = "${homeDirectory}/public/templates";
    };
  };
}
