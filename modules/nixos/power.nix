{ config, lib, ... }:
let
  inherit (lib.modules) mkIf mkDefault;


  MHz = x: x * 1000;
  profiles = config.sylveon.profiles;
in
{

  config = mkIf (builtins.elem "laptop" profiles) {
    # power management (very good)
    services = {
      auto-cpufreq = {
        enable = true;

        settings = {
          battery = {
            governor = "powersave";
            # energy_performance_preference = "power";

            scaling_min_freq = mkDefault (MHz 1200);
            scaling_max_freq = mkDefault (MHz 1800);

            turbo = "never";

            # this enables charging thresholds, this means that the battery will only
            # charge when it's above the start_threshold and stop charging when it's
            # below the stop_threshold
            enable_thresholds = true;
            start_threshold = 20;
            stop_threshold = 80;
          };

          charger = {
            governor = "performance";
            energy_performance_preference = "performance";

            scaling_min_freq = mkDefault (MHz 1800);
            scaling_max_freq = mkDefault (MHz 3800);

            turbo = "auto";
          };
        };
      };

      # Service that provides applications with power management support
      upower = {
        enable = true;

        percentageLow = 20;
        percentageCritical = 10;
        percentageAction = 5;

        criticalPowerAction = "Hibernate";
      };

      # Disable power-management services that are sometimes automatically activated
      power-profiles-daemon.enable = false;
      tlp.enable = false;
    };

  };
}