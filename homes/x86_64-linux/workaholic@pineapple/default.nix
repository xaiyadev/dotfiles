{
  lib,
  pkgs,
  inputs,

  namespace,
  home,
  target,
  format,
  virtual,
  host,

  config,
  ...

}:
with lib;
with lib.sylveon;
{

  /* User specific configurations */
  programs.chromium.extensions = [ { id = "kmcfomidfpdkfieipokbalgegidffkal"; } ]; # Add the enpass browser extension

  sylveon = { # if using namespace here, you will get an error
    cli = {
      kitty = enabled;
      neovim = enabled;
    };

    apps = {
      #music.spotify = enabled; Deprecated!
      music.tidal = enabled;

      browser.chromium = enabled;

      #browser.zen = enabled;

      social = {
        discord = enabled;
        teams = enabled; # This instance is used for work
      };

      development = {
        jetbrains = {
          phpstorm = enabled; # deprecated when completly switched to neovim
        };
      };

      files.obsidian = enabled;
    };

    tools = {
      direnv = enabled;
      git = {
        enable = true;
        user.email = "d.schumin@blmedia.de"; # Deadname :/
      };
    };

  };


  home.stateVersion = "24.05";
}
