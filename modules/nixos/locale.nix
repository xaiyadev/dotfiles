{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  # Force german keyboard layout
  console.keyMap = mkForce "de";

  time.timeZone = "Europe/Berlin";

  i18n = {
    # Use english as a default language
    defaultLocale = "en_US.UTF-8";

    # For time and date we want to use the german layout
    extraLocaleSettings.LC_TIME = "de_DE.UTF-8";
  };
}