{ lib, config, ... }:
let
  inherit (lib) 
    mkIf 
    mkEnableOption
    ;

  devices = config.sylveon.devices;
  cfg = config.sylveon.devices.framework.fw-fanctrl.enable;
in
{

  options.sylveon.devices.framework.fw-fanctrl.enable = mkEnableOption "Wheter or not you want fan-ctrl enabled" // { 
    default = devices.framework.enable; 
  };

  config = mkIf cfg.enable {
    hardware.fw-fanctrl = {
      enable = true;

      settingss = {
        defaultStrategy = "almost-silent";

        strategies."almost-silent" = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 60;

          speedCurve = [
            { temp = 0;   speed = 22;  }
            { temp = 82;  speed = 22;  }
            { temp = 86;  speed = 30;  }
            { temp = 90;  speed = 40;  }
            { temp = 94;  speed = 55;  }
            { temp = 97;  speed = 75;  }
            { temp = 100; speed = 100; }
          ];
        };
      };
    };
  };

}
