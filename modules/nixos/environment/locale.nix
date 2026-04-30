{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  console.keyMap = mkForce "de";

  time = {
    timeZone = "Europe/Berlin";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    # Default language english
    defaultLocale = "en_US.UTF-8";

    # Time/date german
    extraLocaleSettings.LC_TIME = "de_DE.UTF-8";
  };
}
