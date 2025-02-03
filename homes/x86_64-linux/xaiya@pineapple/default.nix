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

  # Add Yubikey u2f_keys
  home.file.".config/Yubico/u2f_keys".text = "xaiya:yJOnhShdxyJpMTbqxhsln9Ce/6IBbbQSSOIxwJK0n9ywBI1Q/jm78gTQCbFvRkGtDIT3y54yPzqQZyz49QZcXw==,xlPjmXzsATgnGr371oxpYqXVtIWUKF2xLum3CfVVldJ2cEnPRAjK1kD3MOvo0egkC/8mxBW2si2edHfuHAJGcw==,es256,+presence";

  sylveon = {

    cli = {
      kitty = enabled;
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
          webstorm = enabled; # deprecated when completly switched to neovim
          intellij = enabled; # Java development, will probably stay with this idea
        };
      };

      games = {
        FFXIV = enabled;
        minecraft = enabled;
        steam = enabled;
      };


      security.yubikey = enabled;
      files.obsidian = enabled;
    };

    tools = {
      direnv = enabled;
      git = enabled;
    };

  };
  home.stateVersion = "24.05";
}
