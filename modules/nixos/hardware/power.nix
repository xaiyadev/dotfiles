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
  config = mkIf prof.laptop.enable {

    # kernel and settings activated on boot to save power
    boot = {
      kernelModules = [ "acpi_call" ];

      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
        cpupower
      ];
    };

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
        enable = true;

        # change profiles based on the battery level
        ppdSettings.main.battery_detection = true;
      };
    };
  };

}
