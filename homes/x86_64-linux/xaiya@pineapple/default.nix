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
        teams = enabled; # This instance will be used for my school account
      };

      development = {
        jetbrains = {
            enable = true; # Enabling syncronization with my git server

            webstorm = enabled; # deprecated when completly switched to neovim
            intellij = enabled; # Java development, will probably stay with this idea
        };
      };

      files.obsidian = enabled;
    };

    tools = {
      direnv = enabled;
      git = enabled;
      ssh = enabled;
    };

  };
  home.stateVersion = "24.05";
}