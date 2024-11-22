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
  cfg = config.${namespace}.system.ssh;
in {

  options.${namespace}.system.ssh = with types; {
    enable = mkBoolOpt false "Whether or not to enable the ssh agent and all its configuration";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 22 ];

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = if format == "install-iso" then "yes" else "no";
        usePAM = true;
      };
    };
  };
}
