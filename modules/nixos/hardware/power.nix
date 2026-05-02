# Configuration just for laptops
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;

  prof = config.sylveon.profiles;
in
{
  config = {

    # kernel and settings activated on boot to save power
    boot = {
      kernelModules = [ "acpi_call" ];

      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
        cpupower
      ];
    };

    # Prevent wakeup from keyboard touch if lid is close
    udev.extraRules = mkIf prof.laptop.eanble ''
      SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
      SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    '';

    # services running on life system to manage power
    services = {
      # handle ACPI events
      acpid.enable = true;

      # DBus service providing power information to applications
      upower = {
        enable = true;
        percentageLow = 20;
        percentageCritical = 8;
        percentageAction = 3;

        criticalPowerAction = "Hibernate";
      };

      # Tuning system for battery management
      tuned = {
        inherit (prof.laptop) enable;

        # change profiles based on the battery level
        ppdSettings.main.battery_detection = true;
      };
    };
  };

}