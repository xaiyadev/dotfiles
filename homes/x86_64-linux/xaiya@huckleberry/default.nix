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

  sylveon = {
    cli = {
      kitty = enabled;
      neovim = enabled;
    };

    apps = {
      music.tidal = enabled;
      browser.chromium = enabled;

      development = {
        jetbrains = {
          enable = true; # Enabling syncronization with my git server

          webstorm = enabled; # deprecated when completly switched to neovim
          intellij = enabled; # Java development, will probably stay with this idea
        };
      };

      social.discord = enabled;
      files.obsidian = enabled;
    };

    tools = {
      direnv = enabled;
      git = enabled;
    };

  };
  home.stateVersion = "24.05";
}
