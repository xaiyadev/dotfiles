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
   programs.ssh.startAgent = true;
   services.openssh = {
      enable = true;
      ports = [ 22 ];

      settings = {
        PasswordAuthentication = true; # Needs to be removed after proper ssh keys made
        PermitRootLogin = if format == "install-iso" then "yes" else "no";
        UsePAM = true;
      };
    };
  };
}
