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

  config = mkIf cfg.enable {
    services.kanshi = {
      enable = true;

      settings = 
      [
        {
          profile = {
            name = "docked_office";
            outputs = [
              {
                criteria = "eDP-2";

                position = "0,0";
                mode = "2560x1600@165.000Hz";
              }
              
              {
                criteria = "Philips Consumer Electronics Company PHL 272B4Q AU11526001821"; # Criteria as name, because its monitor and not slot specific
                position = "2560,80";
                mode = "2560x1440@59.951Hz";
              }

              {
                criteria = "Philips Consumer Electronics Company PHL 272B4Q AU11531001040";

                position = "5120,160";
                mode = "2560x1440@59.951Hz";
              }
            ];
          };
        }


        {
          profile = {
            name = "docked_home";
            outputs = [
              { criteria = "eDP-2"; status = "disable"; }

              {
                criteria = "AOC 2460G4 0x0000A8E2";
                position = "1920,80";
                mode = "1920x1080@119.982Hz";
              }

              {
                criteria = "Acer Technologies RT240Y T75EE0042411";

                position = "0,0";
                mode = "1920x1080@60.000Hz";
              }
            ];
          };
        }
      ];

    };
  };
}
