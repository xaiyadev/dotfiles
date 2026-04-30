# Configuration just for laptops
{
  config,
  ...
}:
{
  config = mkIf config.sylveon.profiles.laptop.enable {
    services = {
      # Tuning system for battery management
      tuned = {
        enable = true;

        # change profiles based on the battery level
        ppdSettings.main.battery_detection = true;
      };
    };
  };

}