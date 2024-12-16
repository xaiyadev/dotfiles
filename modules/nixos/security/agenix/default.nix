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
  cfg = config.${namespace}.security.agenix;

  getSystemDirectory = "${inputs.self}/systems/${system}/${config.networking.hostName}";
in {

  options.${namespace}.security.agenix = with types; {
    enable = mkBoolOpt false "Whether or not to enable agenix encryption and decryption; Needed for system install!";
    masterIdentities = mkOpt (listOf path) [ ./age-yubikey.pub ] "A list of masterIdentities that should be used; defaults to my yubikey";
  };

  /* The default Agenix configuration, with the new age-rekey module
   * The age.rekey.hostPubkey is located in the hosts default file
   * All secret files can be found in the hosts folder ${hostname}/secrets/
   */
  config = mkIf cfg.enable {
    age.rekey = {
      hostPubkey = builtins.readFile (getSystemDirectory + "/key.pub");
      masterIdentities = cfg.masterIdentities;

      # Secrets are located in the local repository
      storageMode = "local";
      localStorageDir = getSystemDirectory + "/secrets/";
    };
  };
}
