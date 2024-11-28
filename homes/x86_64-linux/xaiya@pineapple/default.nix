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
    };

    apps = {
      spotify = enabled;
      discord = enabled;

      #zen = enabled;
      chromium = enabled;
    };

    tools = {
      direnv = enabled;
      git = enabled;
      ssh = enabled;
    };

  };
  home.stateVersion = "24.05";
}