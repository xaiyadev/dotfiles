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
                criteria = "eDP-1";

                position = "0,182";
                mode = "1920x1080@60.049Hz";
              }
              
              {
                criteria = "Philips Consumer Electronics Company PHL 272B4Q AU11526001821"; # Criteria as name, because its monitor and not slot specific
                position = "1920,0";
                mode = "2560x1440@59.951Hz";
              }

              {
                criteria = "Philips Consumer Electronics Company PHL 272B4Q AU11531001040";

                position = "4480,0";
                mode = "2560x1440@59.951Hz";
              }
            ];
          };
        }
      ];

    };
  };
}
