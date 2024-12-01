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
      neovim = enabled;
      zsh = enabled;
    };

    # Apps not needed without desktop environment

    tools = {
      direnv = enabled;
      git = enabled;
      ssh = enabled;
    };

  };

  home.stateVersion = "24.05";
}
