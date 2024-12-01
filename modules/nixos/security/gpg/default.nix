{
  lib,
  pkgs,
  inputs,

  namespace,
  system,
  target,
  format,
  virtual,
  systems,

  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.security.gpg;
in {

  options.${namespace}.security.gpg = with types; {
    enable = mkBoolOpt false "Whether or not to enable the ";
  };

   /* Configure Yubikey and with that use gpg keys */
   # TODO: change SSH keys to GPG keys // create GPG key
  config = mkIf cfg.enable {

  };
}
