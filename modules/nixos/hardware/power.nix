# Configuration just for laptops
{
  config,
  lib,
  pkgs,
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

        profiles = {
          # Our main profile; used for gaming and programming on my main account
          # it is allowed to be loader and we clock down the cpu so that the 
          # shared cpu-gpu heatsink doest get to hot
          fw-performance = {
            main.summary = "Framework 16: Performance heavier and day-to-day use (gaming; home)";
            cpu = {
              energy_performance_preference = "balance_performance";
              boost = 1;
            };
            acpi.platform_profile = "low-power";
          };

          # the office profile; we want it a little bit quiter so it doesnt
          # annoy our co-workers while keeping performance
          fw-quiet = {
            main.summary = "Framework 16: more silent profile";
            cpu = {
              energy_performance_preference = "balance_power";
              boost = 0;
            };
            acpi.platform_profile = "low-power";
          };
        };

        # change profiles based on the battery level
        ppdSettings = {
          main = {
            battery_detection = false; # managing power connection over profiles
            default = "balanced";
          };

          profiles = {
            power-saver = "fw-quiet";
            balanced = "fw-performance";
            performance = "fw-performance";
          };

          battery.balanced = "fw-quiet";
        };
      };
    };
  };
}
