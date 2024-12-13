{ lib, ... }:
with lib;
rec {

  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  /*
   *  Quickly create a boolean option
   *  ```nix
   *  mkBoolOpt true "Description of this Option"
   *  ```
   */
  mkBoolOpt = mkOpt types.bool;

  /*
   *  Quickly enable an option
   *  ```nix
   *  boot.loader.grub = enabled;
   *  ```
   *
   */
  enabled = {
    enable = true;
  };

  /*
   *  Quickly enable an option
   *  ```nix
   *  boot.loader.grub = disabled;
   *  ```
   *
   */
  disabled = {
    enable = false;
  };

  # Access the (potentially nested) attribute in `set`
  # using a dot-delimited path `strPath`.
  # Evaluate to `null` when the attribute does not exist.
  #
  # `strPath`: A dot-delimited string
  # `set`: The attribute set to be accessed
  attrByStrPath = strPath:
    lib.attrsets.attrByPath
      (lib.strings.splitString "." strPath);
  
  /*
   *  Quickly enable an option
   *  ```nix
   *  boot.loader.grub = disabled;
   *  ```
   *
   */
  copyModuleOption = 
    module: attr:
    { inherit module attr; };
}
