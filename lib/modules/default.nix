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
}