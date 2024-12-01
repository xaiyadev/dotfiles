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

  sylveon = { # if using namespace here, you will get an error
    cli = {
      kitty = enabled;
      zsh = enabled;
      neovim = enabled;
    };

    apps = {
      music.spotify = enabled;

      browser.chromium = enabled;

      #browser.zen = enabled;

      social = {
        discord = enabled;
        teams = enabled; # This instance is used for work
      };

      development = {
        webstorm = enabled; # deprecated when completly switched to neovim
      };

      files.obsidian = enabled;
    };

    tools = {
      direnv = enabled;
      git = {
        enable = true;
        user.email = "d.schumin@blmedia.de"; # Deadname :/
      };
      ssh = enabled;
    };

  };

  programs.chromium.extensions = [ { id = "kmcfomidfpdkfieipokbalgegidffkal"; } ]; # Add the enpass browser extension

  home.stateVersion = "24.05";
}
