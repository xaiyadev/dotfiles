{
  lib,
  pkgs,
  inputs,

  namespace,
  target,
  format,
  virtual,
  host,

  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.kanshi;
in {

  options.${namespace}.desktop.addons.kanshi = with types; {
    enable = mkBoolOpt false "Whether or not to enable Kanshi as a monitor manager";
  };

  # TODO: needs testing and readjusting
  config = mkIf cfg.enable {
    services.kanshi = {
      enable = true;

      settings = [

        {

          profile = {
            name = "Docked Office";

            outputs = [
              {
                criteria = "eDP-1";

                position = "0 227";
                mode = "1920x1080@60.049Hz";
              }

              {
                criteria = "Philips Consumer Electronics Company PHL 272B4Q AU11526001821"; # Criteria as name, because its monitor and not slot specific

                position = "1920 0";
                mode = "2560x1440@59.951Hz";
              }

              {
                criteria = "Philips Consumer Electronics Company PHL 272B4Q AU11531001040";

                position = "4480 0";
                mode = "2560x1440@59.951Hz";
              }
            ];
          };

        }

        {

          profile = {
            name = "Tower Huckleberry"; # Will be changed when Huckleberry is deprecated

            outputs = [
              {
                criteria = "HDMI-A-1"; # TODO: change to device name when at Huckleberry station

                position = "1920 0";
                mode = "192.1080@119.982Hz"; # Configuring my only 120Hz Screen :(
              }

              {
                criteria = "DP-3";

                position = "0 0";
                # TODO: mode when at Huckleberry Station
              }
            ];
          };

        }
      ];
    };
  };
}
