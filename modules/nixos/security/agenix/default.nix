{ lib, self, config, ... }:
let
  inherit (lib.types) listOf path;

  inherit (self.lib.modules) mkOpt;
  cfg = config.sylveon.security.agenix;
  getSystemDirectory = "${self}/systems/${config.networking.hostName}"; # TODO: add extra configuration entry?
in {

  options.sylveon.security.agenix = {
    masterIdentities = mkOpt (listOf path) [ ./age-yubikey.pub ] "A list of masterIdentities that should be used; defaults to my yubikey";
  };

  /* The default Agenix configuration, with the new age-rekey module
   * The age.rekey.hostPubkey is located in the hosts default file
   * All secret files can be found in the hosts folder ${hostname}/secrets/
   */
  config = {
    age.rekey = {
      hostPubkey = builtins.readFile (getSystemDirectory + "/key.pub");
      masterIdentities = cfg.masterIdentities;

      # Secrets are located in the local repository
      storageMode = "local";
      localStorageDir = getSystemDirectory + "/secrets/";
    };
  };
}