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
      zsh = enabled;
    };

  };
  home.stateVersion = "24.05";
}